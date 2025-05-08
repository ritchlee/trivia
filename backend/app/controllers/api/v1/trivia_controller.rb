# frozen_string_literal: true

module Api
  module V1
    class TriviaController < ApplicationController
      def question
        genre = params[:genre]
        difficulty = params[:difficulty]

        result = ChatGptTriviaService.new.generate_question(
          genre: genre,
          difficulty: difficulty
        )

        # Check if there was an error generating the question
        if result.key?(:error)
          return render json: { error: result[:error] }, status: :service_unavailable
        end

        # Ensure the response has the expected structure for the mobile app
        # The mobile app expects a question and an array of answers
        if !result.key?(:answers) || !result[:answers].is_a?(Array) || 
           !result.key?(:question) || !result.key?(:correct_answer)
          return render json: { error: "Invalid question format received" }, status: :unprocessable_entity
        end

        render json: result
      end

      def validate
        selected = params[:selected_answer]
        correct = params[:correct_answer]

        render json: { correct: selected.strip.downcase == correct.strip.downcase }
      end
    end
  end
end
