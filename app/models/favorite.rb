class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id }

  def self.ransackable_associations(auth_object = nil)
    ["posts", "details", "labels"]
  end
end
