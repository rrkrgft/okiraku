class AddDefaultToDraftInPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :draft, :boolean, default: false
  end
end
