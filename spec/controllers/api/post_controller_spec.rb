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
      result.push FactoryGirl.create(:post, {user_id: user.id})
    end
    result
  end

  def post_attrs
    @post_attrs ||= FactoryGirl.attributes_for(:post)
  end

  def user_post
    @post ||= FactoryGirl.create(:post, {user_id: user.id})
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
    it 'respond successful and it includes preview, text and title' do
      request.headers['Token'] = token
      post :create, {post: post_attrs}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['preview']).not_to be_empty
      expect(result['text']).not_to be_empty
      expect(result['title']).not_to be_empty
    end

    it 'respond with error status 401' do
      post :create, {post: post_attrs}
      expect(response).to have_http_status(401)
    end
  end

  describe 'PUT /api/post/:id' do
    it 'respond successful and it includes updated post' do
      params = {
          title: 'test',
          preview: 'test',
          text: 'test'
      }
      request.headers['Token'] = token
      put :update, {id: user_post.id, post: params}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['preview']).to eq('test')
      expect(result['text']).to eq('test')
      expect(result['title']).to eq('test')
    end

    it 'respond with error status 400 and it includes message' do
      params = {
          title: '',
          preview: '',
          text: ''
      }
      request.headers['Token'] = token
      put :update, {id: user_post.id, post: params}
      result = JSON.parse response.body
      expect(response).to have_http_status(400)
      expect(result['message']).not_to be_empty
    end

    it 'respond with error status 401' do
      params = {
          title: 'test',
          preview: 'test',
          text: 'test'
      }
      put :update, {id: user_post.id, post: params}
      expect(response).to have_http_status(401)
    end
  end

  describe 'DELETE /api/post/:id' do
    it 'respond successful and it includes status' do
      request.headers['Token'] = token
      delete :destroy, {id: user_post.id}
      result = JSON.parse response.body
      expect(response).to have_http_status(200)
      expect(result['status']).to eq('success')
    end

    it 'respond with error status 401' do
      delete :destroy, {id: user_post.id}
      expect(response).to have_http_status(401)
    end
  end

end
