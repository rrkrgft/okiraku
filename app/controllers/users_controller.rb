class UsersController < ApplicationController
  def index
    set_q
    if params[:q]
      @posts = @q.result.where(user_id: current_user.id)
    else
      @posts = Post.where(user_id: current_user.id)
    end
  end

  private
  def set_q
    @q = Post.ransack(params[:q])
  end
end
