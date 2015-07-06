class Api::PostController < ApiController

  before_action :authorized!, only: [:create, :update, :destroy]
  before_action :post, only: [:show, :update, :destroy]

  def index
    render json: Post.all.page(page)
  end

  def show
    render json: post
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post
    else
      render json: {message: post.errors}, status: 400
    end
  end

  def update
    post.update(post_params)
    if post.save
      render json: post
    else
      render json: {message: post.errors}, status: 400
    end
  end

  def destroy
    if post.destroy
      render json: {status: 'success'}
    else
      render json: {status: 'fail'}
    end
  end


  private

  def page
    params[:page]
  end

  def id
    params[:id]
  end

  def post
    @post ||= Post.find id
  rescue ActiveRecord::RecordNotFound
    render json: {message: t('errors.record_not_found')}, status: 404
    return false
  end

  def post_params
    params.require(:post).permit(:title, :preview, :text)
  end
end
