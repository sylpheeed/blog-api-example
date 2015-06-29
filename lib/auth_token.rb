require 'jwt'

module AuthToken
  def AuthToken.generate(payload, exp: 1.year.from_now.to_i)
    payload[:exp] = exp
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def AuthToken.valid?(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
  end
end
