FactoryBot.define do
  factory :user do
    name { "user" }
    email { "test@example.com" }
    password { "password" }
    admin { false }
  end
end
