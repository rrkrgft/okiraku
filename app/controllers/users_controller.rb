class UsersController < ApplicationController
  def index
    set_q
    @posts = Post.where(user_id: current_user.id)
    if params[:q]
      @posts = @q.result
    end
  end

  private
  def set_q
    @q = Post.ransack(params[:q])
  end
end
