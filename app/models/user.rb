class User < ApplicationRecord
  after_create :make_labels
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :name, presence: true

  has_many :favorites, dependent: :destroy
  has_many :posts, through: :favorites, dependent: :destroy
  has_many :posts
  has_many :details, through: :posts
  has_many :labels

  private
  def make_labels
    user_id = self.id
    Label.create([{user_id: user_id, name: "趣味"},{user_id: user_id, name: "食事"},{user_id: user_id, name: "仕事"},{user_id: user_id, name: "遊び"}])
    # admin権限で初期登録のラベルを変更できるようにする
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "admin"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["posts", "details", "labels"]
  end
end
