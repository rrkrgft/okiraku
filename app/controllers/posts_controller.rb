class PostsController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_user_analysis, only: [:new, :create, :edit, :update, :destroy]

  def new
    @post = Post.new
    detail = @post.build_detail
    session[:previous_url] = request.referer
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.draft = true if !params[:register]
    if @post.save
      if @post.draft
        redirect_to session[:previous_url] || root_path, notice: "下書き登録しました"
      else
        redirect_to session[:previous_url] || root_path, notice: "公開登録しました"
      end
    else
      render :new, notice: "登録エラーです"
    end
  end
  
  def index
    set_q
    if params[:q]
      @posts = @q.result
    else
      @posts = Post.includes(:user).order(created_at: "DESC")
    end
    @posts = @posts.where(draft: false).page(params[:page]).per(10)
  end
  
  def show
    set_post
    check_user_view
  end
  
  def edit
    session[:previous_url] = request.referer
    set_post
    check_user_edit
  end
  
  def update
    set_post
    check_user_edit
    params[:post][:draft] = true if !params[:register]
    if @post.update(post_params)
      if !params[:register]
        redirect_to session[:previous_url] || root_path, notice: "下書き編集しました"
      else
        redirect_to session[:previous_url] || root_path, notice: "編集し公開しました"
      end
    else
      render :edit, notice: "編集エラーです"
    end
  end

  def destroy
    set_post
    check_user_edit
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

  def check_user_view
    redirect_to posts_path, notice: "閲覧権限がありません" if current_user != @post.user && @post.draft == true
  end

  def check_user_edit
    redirect_to posts_path, notice: "編集権限がありません" unless current_user == @post.user
  end
end
