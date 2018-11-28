# frozen_string_literal: true

module Api
  module V1
    # Application API. Herdado por outras classes da pasta Api.
    class ApiController < ApplicationController
      include Knock::Authenticable
      include CanCan::ControllerAdditions

      rescue_from ActiveRecord::RecordNotFound do |msg|
        render(json: { message: msg }, status: :not_found)
      end

      rescue_from ActionController::ParameterMissing do |exception|
        render(json: { message: exception.param }, status: :bad_request)
      end

      rescue_from CanCan::AccessDenied do |msg|
        render(json: { message: msg }, status: :forbidden)
      end

      # Refresh o token JWT.
      def new_jwt
        Knock::AuthToken.new(payload: { sub: current_user.id }).token
      end

      # Envia novo token ao usuario logado a cada resposta.
      def render(options = nil, extra_options = {}, &block)
        options ||= {}
        options[:json][:jwt] = new_jwt if json_response?(options) && logged_in?
        super(options, extra_options, &block)
      end

      private

      def json_response?(options)
        options[:json].is_a?(Hash)
      end

      def logged_in?
        current_user.present?
      end
    end
  end
end
