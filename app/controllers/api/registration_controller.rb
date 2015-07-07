class Api::RegistrationController < ApiController

  def create
    user = User.new(registration_params)
    if user.save
      render json: {user: user, token: AuthToken.generate({id: user.id})}
    else
      render json: {message: user.errors}, status: 400
    end
  rescue => e
    render json: {message: e.to_s}, status: 400
  end

  private

  def registration_params
    params.require(:registration).permit(:email, :password)
  end
end
