class V1::Admin::ReportsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    page = strong_params[:page]

    render json: Report.page(page).per(50)
  end

  def all_reports
    render json: Report.all
  end

  protected

  def strong_params
    params.permit(:page)
  end
end
