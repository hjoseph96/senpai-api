# frozen_string_literal: true

class V1::Admin::ReportsController < ApplicationController
  def index
    page = strong_params[:page].nil? ? 1 : strong_params[:page]

    @reports  = Report.order(created_at: :desc).page(page).per(50)

    render json: @reports
  end

  def show
    @report = Report.find(strong_params['id'])

    render json: @report
  end

  def resolve
    @report = Report.find(strong_params['id'])
    @report.resolved!

    render json: @report.reload
  end

  protected

  def strong_params
    params.permit(:page, :id)
  end
end

