class Label < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :labelings
end
