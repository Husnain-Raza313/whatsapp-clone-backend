module HandleSessionExpiryConcern
  extend ActiveSupport::Concern

  def session_expiry
    return if get_session_time_left
    session[:session_token] = nil
    render json: { message: 'Your session has been timeout please Login again' }
  end

  def get_session_time_left
    @session_time_left = (Time.now.to_time.to_i - session[:expires_at].to_time.to_i).abs
    @session_time_left < 100
  end

  def check_session_token
    render json: { message: 'Invalid Session Token' } unless params[:token] && params[:token] == session[:session_token]
  end
end
