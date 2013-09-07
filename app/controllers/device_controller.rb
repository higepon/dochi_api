class DeviceController < ApplicationController
  before_filter :_login
  def update
    device = Device.where(:token => params[:token], :user_id => @user.id)
    if device.empty?
      device = Device.new(:token => params[:token], :user_id => @user.id)
      device.save!
    end
    render json: { :status => :ok }
  rescue => e
    render json: { :status => :error }, :status => :bad_request
  end
end
