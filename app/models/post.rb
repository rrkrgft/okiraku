class Post < ApplicationRecord
  validates :title, presence: true
  validates :draft, presence: true

  belongs_to :user
  has_one :detail, dependent: :destroy
  accepts_nested_attributes_for :detail, allow_destroy: true
end
