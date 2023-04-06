class Detail < ApplicationRecord
  belongs_to :post

  private
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "public", "secret", "deeply", "secret_choice_deep", "post_id", "updated_at"]
  end
end
