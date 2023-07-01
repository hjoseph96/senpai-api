class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authorize_request
    
    def not_found
      render json: { error: 'not_found' }
    end
  
    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header

      begin
        @decoded = JsonWebToken.decode(header)
        @current_user = User.find(@decoded[:user_id])

        render json: { status: 'access_denied' } if @current_user.nil?

        render json: { user: @current_user }
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end

    def verify_requests
        @pending_requests =  VerifyRequest.where(status: :pending)
    end
  end
  