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

  describe "GET /api/session" do
    it 'responds successfully with including status true and user information' do
      request.headers['Token'] = token
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['status']).to eq(true)
      expect(result['user']['id']).to eq(user.id)
    end

    it 'responds successfully with status false' do
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['status']).to eq(false)
    end
  end

  describe 'POST /session' do
    it 'responds successfully with user and token params' do
      post :create, {user: {email: user_attrs[:email], password: user_attrs[:password]}}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['token']).to eq(token)
      expect(result['user']['id']).to eq(user.id)
    end

    it 'responds with error status 400 and including message' do
      post :create
      expect(response).to have_http_status(400)
    end
  end
end
