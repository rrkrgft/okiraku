class PostsController < ApplicationController
  def new
    @post = Post.new
    @detail = Detail.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "登録しました"
    else
      render :new, notice: "登録エラーです"
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  private
  def post_params
    params.require(:post).permit(:title, :score, :image, :draft, detail_attributes: [:public, :secret, :deeply, :secret_choice_deep, :_destroy, :id])
  end
end
