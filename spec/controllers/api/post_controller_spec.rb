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


  def posts
    @posts ||= create_posts
  end

  def create_posts
    result = []
    20.times do
      result.push FactoryGirl.create(:post)
    end
    result
  end

  def post_attrs
    @attrs ||= FactoryGirl.attributes_for(:post)
  end

  def random_post
    posts.sample
  end

  before :each do
    user
  end

  describe 'GET /api/post' do
    before :each do
      posts
    end
    it 'respond successful and it includes 10 elements' do
      get :index
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result.length).to eq(10)
    end

    it 'request to page 3, respond successful and it includes 0 elements' do
      get :index, {page: 3}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result.length).to eq(0)
    end
  end

  describe 'GET /api/post/:id' do
    it 'respond successful and it includes preview, text and title ' do
      get :show, {id: random_post.id}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['preview']).not_to be_empty
      expect(result['text']).not_to be_empty
      expect(result['title']).not_to be_empty
    end

    it 'respond with error status 404 and it includes message' do
      get :show, {id: 0}
      result = JSON.parse response.body
      expect(response).to have_http_status(404)
      expect(result['message']).not_to be_empty
    end
  end

  describe 'POST /api/post' do
    it 'respond successful' do
      post :create, {post: post_attrs}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /api/post/:id' do
    it 'respond successful' do
      put :update, {id: 1}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /api/post/:id' do
    it 'respond successful' do
      delete :destroy, {id: 1}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
    end

  end

end
