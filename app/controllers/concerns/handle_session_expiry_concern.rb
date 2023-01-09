module HandleSessionExpiryConcern
  extend ActiveSupport::Concern

  def session_expiry
    get_session_time_left
    return if @session_time_left < 1000
    session[:session_token] = nil
    render json: { message: 'Your session has been timeout please Login again' }
  end

  def get_session_time_left
    @session_time_left = (Time.now.to_time.to_i - session[:expires_at].to_time.to_i).abs
  end

  def check_session_token
    render json: { message: 'Invalid Session Token' } unless params[:token] && params[:token] == session[:session_token]
  end
end
