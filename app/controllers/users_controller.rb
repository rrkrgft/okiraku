class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    set_q
    if params[:q]
      @posts = @q.result.where(user_id: current_user.id).page(params[:page])
    else
      @posts = Post.where(user_id: current_user.id).page(params[:page])
    end
  end

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
  end

  private
  def set_q
    @q = Post.ransack(params[:q])
  end
end
