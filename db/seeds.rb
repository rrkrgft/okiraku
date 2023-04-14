# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  name: Faker::Name.first_name,
  email: "user1@example.com",
  password: "password",
  admin: true
)

4.times do |n|
  User.create!(
    name: Faker::Name.first_name,
    email: "user#{n+2}@example.com",
    password: "password" )
end

# labels = %w(趣味 仕事 自己学習 遊び スポーツ 読書 映画 ドラマ 料理 散歩 登山 旅行 友達 一人 同僚 家族 恋人).sample(3)

m = 1
5.times do |n|
  User.all.each do |user|
    user.posts.create(
      title: "test_title#{m}",
      score: rand(21) * 5,
      draft: [ true, false].sample,
      detail_attributes: { 
        public: "detail_public#{m}",
        secret: "detail_secret#{m}",
        deeply: "detail_deeply#{m}",
        secret_choice_deep: [ true, false].sample
      }
    )
    m += 1
  end
end

User.all.each do |user|
  not_my_posts = Post.where.not(user_id: user.id).where(draft: false)
  3.times do |n|
    count = rand(0...not_my_posts.count)
    post = not_my_posts[count].id
    Favorite.create(user_id: user.id, post_id: post)
  end
end

User.all.each do |user|
  user.posts.each do |post|
    2.times do |n|
      Labeling.create(label_id: rand(0...17), post_id: post.id)
    end
  end
end
