require 'rails_helper'
RSpec.describe Api::SessionController, :type => :controller do

  def user_attrs
    @attrs ||= FactoryGirl.attributes_for(:user)
  end

  def user
    @user ||= FactoryGirl.create(:user, user_attrs)
  end

  def token
    @token ||= AuthToken.generate({id: user.id})
  end


  before :each do
    user
  end

  describe 'GET /api/session' do
    it 'responds successful and it includes status true and user information' do
      request.headers['Token'] = token
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['status']).to eq(true)
      expect(result['user']['id']).to eq(user.id)
    end

    it 'respond successful and status false' do
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['status']).to eq(false)
    end
  end

  describe 'POST /api/session' do
    it 'respond successful and it includes user and token params' do
      post :create, {user: {email: user_attrs[:email], password: user_attrs[:password]}}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['token']).to eq(token)
      expect(result['user']['id']).to eq(user.id)
    end

    it 'respond with error status 400' do
      post :create
      expect(response).to have_http_status(400)
    end
  end

end
