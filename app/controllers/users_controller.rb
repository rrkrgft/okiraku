class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    set_q
    if params[:q]
      @posts = @q.result
    else
      @posts = Post.includes(:detail)
    end
    @posts = @posts.where(user_id: current_user.id).page(params[:page]).per(10)
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
  end

  def guest_admin_sign_in
    user = User.guest_admin
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザー（管理者）としてログインしました'
  end

  def guest_analysis_sign_in
    user = User.guest_analysis
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザー（分析確認用）としてログインしました'
  end

  private
  def set_q
    @q = Post.ransack(params[:q])
  end
end
