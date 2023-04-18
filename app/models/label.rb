class Label < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_many :labelings, dependent: :destroy

  private
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name"]
  end
end
