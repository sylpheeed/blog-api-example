require 'rails_helper'

RSpec.describe Api::PostController, :type => :controller do

  def user_attrs
    @attrs ||= FactoryGirl.attributes_for(:user)
  end

  def user
    @user ||= FactoryGirl.create(:user, user_attrs)
  end

  def token
    @token ||= AuthToken.generate({id: user.id})
  end


  describe 'api/post_controller' do
    before :each do
      user
    end

    describe 'GET /api/post' do
      it 'responds successful' do
        get :index
        result = JSON.parse response.body
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /api/post' do
      it 'responds successful' do
        post :show
        result = JSON.parse response.body
        expect(response).to have_http_status(200)
      end
    end

    describe 'PUT /api/post' do
      it 'responds successful' do
        put :update
        result = JSON.parse response.body
        expect(response).to have_http_status(200)
      end
    end

    describe 'DELETE /api/post' do
      it 'responds successful' do
        delete :destroy
        result = JSON.parse response.body
        expect(response).to have_http_status(200)
      end

    end
  end
end
