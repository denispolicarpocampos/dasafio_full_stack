# frozen_string_literal: true

module Api
  module V1
    # Classe que gera novo token para usuario e autentica.
    class UserTokenController < Knock::AuthTokenController
      skip_before_action :verify_authenticity_token
    end
  end
end
