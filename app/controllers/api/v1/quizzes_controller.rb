# frozen_string_literal: true

module Api
  module V1
    # Classe controladora de quizes
    class QuizzesController < Api::V1::ApiController
      before_action :authenticate_user
      before_action :set_quiz, only: %i[show destroy update]
      load_and_authorize_resource

      def index
        quizzes = Quiz.paginate(page: params[:page], per_page: 15)
        return render json: quizzes if current_user.has_role? :admin

        quizzes = Quiz.where(evaluator_id: current_user.id).paginate(page: params[:page], per_page: 15)
        render json: quizzes
      end

      def create
        quiz = Api::V1::CreateQuizesService.new(quiz_params).call
        if quiz == 'true'
          render json: { message: 'Created with success!' }
        elsif quiz == 'false'
          render json: { message: 'Evaluator has no available users to evaluate' }, status: :unprocessable_entity
        else
          render json: { errors: quiz }, status: :unprocessable_entity
        end
      end

      def update
        if @quiz.update(quiz_params.except(:evaluator_id, :evaluated_id))
          render json: @quiz
        else
          render json: { errors: @quiz.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @quiz.destroy
      end

      def show
        render json: @quiz
      end

      private

      def quiz_params
        params.require(:quiz).permit(:title, :proactivity,:evaluator_id, :organization, :flexibility, :efficiency, :team_work, :evaluated).merge!(user_id: current_user.id)
      end

      def set_quiz
        @quiz = Quiz.find(params[:id])
      end
    end
  end
end
