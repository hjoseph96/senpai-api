class V1::Admin::UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    page = strong_params[:page]
    render json: User.profile_filled.where(is_fake_profile: false).page(page).per(50)
  end

  def show
    @user = User.find(strong_params[:id])
    render json: @user
  end

  def destroy
    @user = User.find(strong_params[:id])

    render json: { success: true } if @user.destroy
  end

  def all_users
    render json: User.profile_filled.where(is_fake_profile: false)
  end

  def ban_user
    @user = User.find(strong_params['user_id'])
    @user.update!(banned: !@user.banned)

    render json:  @user.reload
  end

  def warn_user
    @user = User.find(strong_params['user_id'])
    @user.update!(warning_count: @user.warning_count + 1)

    PushNotification.create(
      user_id: @user.id,
      event_name: 'warn_user',
      content: "You've been warned."
    )

    render json:  @user.reload
  end

  protected

  def strong_params
    params.permit(:page, :id, :user_id, :ban)
  end
end
