module HandleSessionExpiryConcern
  extend ActiveSupport::Concern

  def session_expiry
    return if get_session_time_left

    session[:session_token] = nil
    session[:login_time] = nil
    render json: { message: 'Your session has been timeout please Login again' }
  end

  def get_session_time_left
    session[:login_time] ? (Time.now.to_time.to_i - session[:login_time].to_time.to_i).abs < ApplicationHelper::SESSION_EXPIRY_DURATION : true
  end

  def check_session_token
    render json: { message: 'Invalid Session Token' } unless params[:token] && params[:token] == session[:session_token]
  end
end
