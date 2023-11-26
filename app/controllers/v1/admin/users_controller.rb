class V1::Admin::UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    page = strong_params[:page]

    render json: User.page(page).per(50)
  end

  def map_data
    render json: User.all
  end

  protected

  def strong_params
    params.permit(:page)
  end
end
