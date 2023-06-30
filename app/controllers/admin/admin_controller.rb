class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    
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
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end
  end
  