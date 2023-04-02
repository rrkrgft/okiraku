class Post < ApplicationRecord
  validates :title, presence: true
  validates :draft, presence: true, 
  belongs_to :user
  has_one :detail
end
