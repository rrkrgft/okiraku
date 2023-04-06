class Label < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :labelings

  private
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end
end
