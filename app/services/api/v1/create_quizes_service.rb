# frozen_string_literal: true

module Api
  module V1
    # Classe de servico que atribui formularios para usuarios
    class CreateQuizesService
      def initialize(quiz_params)
        @quiz_params = quiz_params.extract!(:title, :evaluator_id, :user_id)
      end

      def call
        availables = User.find(@quiz_params[:evaluator_id]).user_relations
        Quiz.transaction do
          availables.each do |a|
            @quiz = Quiz.create(@quiz_params.merge!(evaluated_id: a.user2_id))
            return @quiz.errors.full_messages if @quiz.errors.present?
          end
        end

        return 'true' if @quiz.present?

        'false'
      end
    end
  end
end
