class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
    detail = @post.build_detail
    session[:previous_url] = request.referer
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to session[:previous_url], notice: "登録しました"
    else
      render :new, notice: "登録エラーです"
    end
  end

  def index
    set_q
    if params[:q]
      @posts = @q.result
    else
      @posts = Post.all
    end    
  end

  def show
    set_post
  end

  def edit
    session[:previous_url] = request.referer
    set_post
  end

  def update
    set_post
    if @post.update(post_params)
      redirect_to session[:previous_url], notice: "編集しました"
    else
      render :edit, notice: "編集エラーです"
    end
  end

  def destroy
    set_post
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました"
  end

  private
  def post_params
    params.require(:post).permit(:title, :score, :draft, detail_attributes: [:public, :secret, :deeply, :secret_choice_deep, :_destroy, :id], label_ids: [] , images: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_q
    @q = Post.ransack(params[:q])
  end
end
