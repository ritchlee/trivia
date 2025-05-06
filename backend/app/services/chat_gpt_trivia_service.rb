# frozen_string_literal: true

class ChatGptTriviaService
  require 'faraday'
  require 'json'

  def initialize
    @api_key = ENV['OPENAI_API_KEY']
    @client = Faraday.new(
      url: 'https://api.openai.com/v1',
      headers: {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/json'
      }
    )
  end

  # rubocop:disable Metrics/MethodLength
  def generate_question(genre:, difficulty:)
    prompt = <<~PROMPT
      Generate a #{difficulty} multiple-choice music trivia question about #{genre}.
      Include 1 correct answer and 3 plausible incorrect answers in JSON format:
      {
        "question": "...",
        "answers": ["A", "B", "C", "D"],
        "correct_answer": "A"
      }
    PROMPT

    response = @client.post('/chat/completions') do |req|
      req.body = {
        model: 'gpt-4',
        messages: [{ role: 'user', content: prompt }],
        temperature: 0.7
      }.to_json
    end

    json = JSON.parse(response.body)
    content = json['choices'][0]['message']['content']
    JSON.parse(content)
  rescue StandardError => e
    { error: e.message }
  end
  # rubocop:enable Metrics/MethodLength
end
