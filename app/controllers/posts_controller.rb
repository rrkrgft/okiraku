class PostsController < ApplicationController
  def new
    @post = Post.new
    detail = @post.build_detail
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "登録しました"
    else
      render :new, notice: "登録エラーです"
    end
  end

  # def create
  #   @post = Post.create(post_params)
  #   @post.user_id = current_user.id
  #   if @post.save
  #     redirect_to posts_path, notice: "登録しました"
  #   else
  #     render :new, notice: "登録エラーです"
  #   end
  # end

  def index
    @posts = Post.all
  end

  def show
    set_post
  end

  def edit
    
  end

  private
  def post_params
    params.require(:post).permit(:title, :score, :image, :draft, detail_attributes: [:public, :secret, :deeply, :secret_choice_deep, :_destroy, :id])
  end

  def detail_params
    params.require(:post).permit(detail: [:public, :secret, :deeply, :secret_choice_deep, :_destroy, :id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
