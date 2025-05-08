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
      Include 1 correct answer and 3 plausible incorrect answers in JSON format:
      {
        "question": "...",
        "answers": ["A", "B", "C", "D"],
        "correct_answer": "A"
      }
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
      parsed_content = JSON.parse(content)
      
      Rails.logger.info("Successfully generated question about #{genre}")
      parsed_content
    rescue Faraday::Error => e
      Rails.logger.error("Network error connecting to OpenAI: #{e.message}")
      { error: "Network error: #{e.message}" }
    rescue JSON::ParserError => e
      Rails.logger.error("JSON parsing error: #{e.message}, Content: #{content.inspect}")
      { error: "Failed to parse OpenAI response: #{e.message}" }
    rescue StandardError => e
      Rails.logger.error("Unexpected error in ChatGptTriviaService: #{e.class} - #{e.message}")
      { error: "Unexpected error: #{e.message}" }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
