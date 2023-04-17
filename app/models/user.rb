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
    initial_labels = %w(趣味 仕事 自己学習 遊び スポーツ 読書 映画 ドラマ 料理 食事 散歩 登山 旅行 友達 一人 同僚 家族 恋人)
    label_box = []
    initial_labels.each do |l|
      label_box << {user_id: user_id, name: l}
    end
    Label.create(label_box)
    # 追加機能としてadmin権限で初期登録のラベルを変更できるようにする
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "admin"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["posts", "details", "labels"]
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  def self.guest_admin
    find_or_create_by!(email: 'guest-admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.admin = true
    end
  end
end
