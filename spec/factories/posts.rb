FactoryBot.define do
  factory :post do
    title { "title_post1" }
    score { 50 }
    draft { false }
    # association :detail, factory: :detail
  end
  factory :post2 do
    title { "title_post2" }
    score { 80 }
    draft { false }
  #   association :detail2
  end
  # factory :post3 do
  #   title { "title_post3" }
  #   score { 100 }
  #   draft { false }
  #   association :detail3
  # end
end
