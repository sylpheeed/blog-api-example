class Api::PostController < ApiController

  def index
    render json: Post.all.page(page)
  end

  def show
    render json: post
  rescue ActiveRecord::RecordNotFound
    render json: {message: t('errors.record_not_found')}, status: 404
  end

  def create

    render json: {}
  end

  def update
    render json: {}

  end

  def destroy
    render json: {}

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
  end
end
