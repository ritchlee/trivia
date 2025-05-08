# frozen_string_literal: true

class ChatGptTriviaService
  require 'faraday'
  require 'json'

  def initialize
    @api_key = ENV['OPENAI_API_KEY']
    @client = Faraday.new(
      url: 'https://api.openai.com',
      headers: {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json'
      }
    )
  end

  # rubocop:disable Metrics/MethodLength
  def generate_question(genre:, difficulty:)
    # Check if API key is present
    if @api_key.nil? || @api_key.empty?
      Rails.logger.error("OpenAI API key is missing")
      return { error: "OpenAI API key is missing. Please set the OPENAI_API_KEY environment variable." }
    end

    prompt = <<~PROMPT
      Generate a #{difficulty} multiple-choice music trivia question about #{genre}.
      
      Your response MUST be valid JSON that strictly follows this format:
      {
        "question": "The full text of the trivia question",
        "answers": ["First answer option", "Second answer option", "Third answer option", "Fourth answer option"],
        "correct_answer": "The exact text of the correct answer from the answers array"
      }
      
      Do not include any explanations, markdown formatting, or additional text outside the JSON object.
      Ensure the "correct_answer" value exactly matches one of the items in the "answers" array.
    PROMPT

    begin
      Rails.logger.info("Sending request to OpenAI API for #{genre} question with #{difficulty} difficulty")
      Rails.logger.info("Using API URL: #{@client.url_prefix}/v1/chat/completions")
      
      response = @client.post('/v1/chat/completions') do |req|
        req.body = {
          model: 'gpt-4',
          messages: [{ role: 'user', content: prompt }],
          temperature: 0.7
        }.to_json
      end
      
      Rails.logger.info("OpenAI API response status: #{response.status}")
      
      if response.status != 200
        Rails.logger.error("OpenAI API error: #{response.body}")
        return { error: "OpenAI API returned error: #{response.status} - #{response.body}" }
      end
      
      json = JSON.parse(response.body)
      
      if !json['choices'] || json['choices'].empty? || !json['choices'][0]['message']
        Rails.logger.error("Unexpected OpenAI response format: #{json}")
        return { error: "Unexpected response format from OpenAI" }
      end
      
      content = json['choices'][0]['message']['content']
      
      # Log the raw content for debugging
      Rails.logger.info("Raw content from OpenAI: #{content}")
      
      begin
        parsed_content = JSON.parse(content)
        
        # Validate the structure of the parsed content
        unless parsed_content.is_a?(Hash) && 
               parsed_content.key?('question') && 
               parsed_content.key?('answers') && 
               parsed_content.key?('correct_answer') &&
               parsed_content['answers'].is_a?(Array)
          
          Rails.logger.error("Invalid JSON structure from OpenAI: #{parsed_content.inspect}")
          return { 
            error: "OpenAI returned invalid JSON structure. Expected question, answers array, and correct_answer." 
          }
        end
        
        # Ensure answers is an array with at least 2 items
        if parsed_content['answers'].length < 2
          Rails.logger.error("Not enough answers in response: #{parsed_content['answers'].inspect}")
          return { error: "OpenAI returned insufficient answer options" }
        end
        
        Rails.logger.info("Successfully generated question about #{genre}")
        parsed_content
      rescue JSON::ParserError => e
        # Try to extract JSON from the content if it's embedded in text
        Rails.logger.warn("Initial JSON parsing failed, attempting to extract JSON from text")
        
        # Look for JSON-like structure in the content
        if content =~ /\{.*\}/m
          json_str = content.match(/(\{.*\})/m)[1]
          begin
            extracted_json = JSON.parse(json_str)
            
            # Validate the extracted JSON
            if extracted_json.key?('question') && 
               extracted_json.key?('answers') && 
               extracted_json.key?('correct_answer') &&
               extracted_json['answers'].is_a?(Array)
              
              Rails.logger.info("Successfully extracted valid JSON from text")
              return extracted_json
            end
          rescue JSON::ParserError
            # If extraction fails, fall through to the error case
            Rails.logger.error("Failed to extract valid JSON from text")
          end
        end
        
        # If we get here, both parsing attempts failed
        Rails.logger.error("JSON parsing error: #{e.message}, Content: #{content.inspect}")
        { error: "Failed to parse OpenAI response: #{e.message}" }
      end
    rescue Faraday::Error => e
      Rails.logger.error("Network error connecting to OpenAI: #{e.message}")
      { error: "Network error: #{e.message}" }
    rescue JSON::ParserError => e
      # This catch is for the outer JSON.parse of the OpenAI response body
      Rails.logger.error("JSON parsing error in OpenAI response body: #{e.message}")
      { error: "Failed to parse OpenAI API response: #{e.message}" }
    rescue StandardError => e
      Rails.logger.error("Unexpected error in ChatGptTriviaService: #{e.class} - #{e.message}")
      { error: "Unexpected error: #{e.message}" }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
