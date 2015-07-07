require 'rails_helper'

RSpec.describe Api::RegistrationController, :type => :controller do

  def user_attrs
    @attrs ||= FactoryGirl.attributes_for(:user)
  end

  describe 'POST /api/registration' do
    it 'responds successful and it includes status true and user information' do
      post :create, {registration: user_attrs}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['user']).not_to be_empty
      expect(result['token']).not_to be_empty
    end

    it 'respond with status code 400 and it includes message' do
      post :create
      result = JSON.parse response.body
      expect(response).to have_http_status(400)
      expect(result).not_to be_empty
    end
  end
end
