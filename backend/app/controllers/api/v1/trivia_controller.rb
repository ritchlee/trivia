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
