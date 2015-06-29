class ApplicationController < ActionController::Base
  include Sorcery::Controller
  include ActionController::Serialization
  include ActionController::Cookies


  before_filter :set_locale

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

  def only_admin
    if logged_in? && current_user.admin?
      true
    else
      render text: '', status: 401
      false
    end
  end

  def support_or_admin
    if logged_in? && (current_user.admin? || current_user.support?)
      true
    else
      render text: '', status: 401
      false
    end
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


  def set_locale
    if logged_in? && current_user.locale.present?
      params[:locale] = current_user.locale
    else
      params[:locale] = language_header
    end

    I18n.locale = locale_exist?(params[:locale]) ? params[:locale] : DEFAULT_LOCALE
  end

  def locale_exist?(locale)
    %w(ru en).include?(locale)
  end

  def language_header
    if request.env['HTTP_ACCEPT_LANGUAGE'].present?
      request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
  end

end
