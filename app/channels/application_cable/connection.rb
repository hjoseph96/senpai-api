module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      return reject_unauthorized_connection if request.params.try(:[], :token).nil?

      begin
        @decoded = JsonWebToken.decode(request.params[:token])
      rescue JWT::VerificationError
        return reject_unauthorized_connection
      end

      return reject_unauthorized_connection if @decoded.try(:[], :user_id).nil?

      @current_user = User.find(@decoded[:user_id])
      if @current_user.present?
        @current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
