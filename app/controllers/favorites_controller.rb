class FavoritesController < ApplicationController
  def create
    Favorite.create(user_id: current_user.id, post_id: params[:format])
    redirect_back(fallback_location: root_path, notice: "お気に入りに登録しました")
    # redirect_to posts_path, notice: "お気に入りに登録しました"
  end

  def destroy
    favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:id])
    favorite.destroy
    redirect_back(fallback_location: root_path, notice: "お気に入りの解除をしました")
  end

  def index
    set_q
    favorites = Favorite.where(user_id: current_user.id).pluck(:post_id)
    if params[:q]
      @posts = @q.result.where(id: favorites).where(draft: false)
    else
      @posts = Post.where(id: favorites).where(draft: false)
    end
  end

  private
  def set_q
    @q = Post.ransack(params[:q])
  end
end
