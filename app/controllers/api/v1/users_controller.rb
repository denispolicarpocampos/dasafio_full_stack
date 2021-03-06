# frozen_string_literal: true

module Api
  module V1
    # Classe de usuarios
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user, except: %i[create]
      before_action :set_user, only: %i[show destroy update]
      load_and_authorize_resource except: %i[create current]

      def index
        users = User.paginate(page: params[:page], per_page: 15)
        render json: users
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user.as_json({:include => :user_relations})
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
      end

      def show
        render json: @user.as_json({:include => :user_relations})
      end

      def current
        render json: current_user
      end

      private

      def user_params
        params.require(:user).permit(:name, :last_name, :email,
                                      :password,
                                      user_relations_attributes: [:id, :user_id, :user2_id, :_destroy])
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
