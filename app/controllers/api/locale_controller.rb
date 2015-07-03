class Api::LocaleController < ApiController

  def index
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    response = {
        locale: I18n.locale.to_s,
        translations: I18n.backend.as_json['translations'][I18n.locale.to_s]
    }
    render json: response
  end

end
