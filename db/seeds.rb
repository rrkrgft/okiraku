# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do |n|
  User.create!(
    name: Faker::Name.first_name,
    email: "user#{n+1}@example.com",
    password: "password" )
end

choice_boolean = [ true, false].sample
score = rand(21) * 5
# labels = %w(趣味 仕事 自己学習 遊び スポーツ 読書 映画 ドラマ 料理 散歩 登山 旅行 友達 一人 同僚 家族 恋人).sample(3)

m = 1
5.times do |n|
  User.all.each do |user|
    user.posts.create(
      title: "test_title#{m}",
      score: score,
      draft: choice_boolean,
      detail_attributes: { 
        public: "detail_public#{m}",
        secret: "detail_secret#{m}",
        deeply: "detail_deeply#{m}",
        secret_choice_deep: choice_boolean,
      }
    )
    m += 1
  end
end
