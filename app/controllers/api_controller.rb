class ApiController < ActionController::Base
  include Sorcery::Controller
  include ActionController::Serialization

  DEFAULT_LOCALE = 'en'

  def default_serializer_options
    {root: false}
  end

  def current_user
    @current_user ||= user_from_token
    @current_user.id ? @current_user : false
  end

  def authorized!
    unless logged_in?
      render text: '', status: 401
      false
    end
  end

  def logged_in?
    current_user.present?
  end

  def user_from_token
    begin
      session = AuthToken.valid?(token)
      User.find session['id']
    rescue => e
      logger.warn "AUTH SESSION FAIL: #{e.to_s}"
      User.new
    end
  end

  def token
    request.headers['Token']
  end

  private


end
