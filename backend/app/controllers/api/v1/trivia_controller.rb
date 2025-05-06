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

        # Ensure the response has the expected structure for the mobile app
        # The mobile app expects a question and an array of answers
        if !result.key?(:answers) || !result[:answers].is_a?(Array)
          # If answers is missing or not an array, create a default structure
          result = {
            question: result[:question] || "Question not available",
            answers: result[:answers].is_a?(Array) ? result[:answers] : [],
            correct_answer: result[:correct_answer] || ""
          }
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
