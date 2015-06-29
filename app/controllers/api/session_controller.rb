class Api::SessionController < ApiController

  def index
    if logged_in?
      render json: {status: true, user: current_user}
    else
      render json: {status: false}
    end
  end

  def create
    params = user_params
    user = User.authenticate(params[:email], params[:password])
    logger.warn user_params
    if user
      render json: {
                 token: AuthToken.generate({id: user.id}),
                 user: user
             }
    else
      raise 'invalid email or password'
    end

  rescue => e
    render json: {message: I18n.t('login.error.invalid')}, status: 400
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
