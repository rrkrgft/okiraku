class Post < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
  has_one :detail, dependent: :destroy
  accepts_nested_attributes_for :detail, allow_destroy: true
end
