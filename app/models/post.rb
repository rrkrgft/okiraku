class Post < ApplicationRecord
  validates :title, presence: true

  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
  has_one :detail, dependent: :destroy
  accepts_nested_attributes_for :detail, allow_destroy: true

  private
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "title", "image", "score", "draft", "user_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["details", "labels", "labelings"]
  end
end
