FactoryBot.define do
  factory :detail do
    public { "public" }
    secret { "secret" }
    deeply { "deeply" }
    secret_choice_deep { false }
    # association :post, factory: :post
  end
  # factory :detail2 do
  #   public { "public_post2" }
  #   secret { "secret_post2" }
  #   deeply { "deeply_post2" }
  #   secret_choice_deep { false }
  # end
  # factory :detail3 do
  #   public { "public_post3" }
  #   secret { "secret_post3" }
  #   deeply { "deeply_post3" }
  #   secret_choice_deep { false }
  # end
end