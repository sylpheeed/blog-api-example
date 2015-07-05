require 'rails_helper'
RSpec.describe Api::LocaleController, :type => :controller do

  describe 'GET /api/locale' do
    it 'respond successful and it includes locale and translations' do
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['locale']).not_to be_empty
      expect(result['translations']).not_to be_empty
    end
  end
end
