class Admin::UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    page = strong_params[:page] ? strong_params[:page] : 1

    User.all.page(page).per_page(50)
  end

  protected

  def strong_params
    params.require(:page)
  end
end
