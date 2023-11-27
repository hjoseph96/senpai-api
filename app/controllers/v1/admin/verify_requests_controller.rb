# frozen_string_literal: true

class V1::Admin::VerifyRequestsController < ApplicationController
  def index
    page = strong_params[:page].nil? ? 1 : strong_params[:page]

    @requests  = VerifyRequest.order(created_at: :desc).page(page).per(50)

    render json: @requests
  end

  def show
    @request = VerifyRequest.find(strong_params['id'])

    render json: @request
  end

  def approve
    @request = VerifyRequest.find(strong_params['id'])

    @request.approve!

    render json: @request.reload
  end

  def deny
    @request = VerifyRequest.find(strong_params['id'])

    @request.deny!

    render json: @request.reload
  end

  protected

  def strong_params
    params.permit(:page, :id)
  end
end

