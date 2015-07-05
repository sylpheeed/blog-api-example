FactoryGirl.define do
  factory :post do
    user nil
    title { Faker::Name.title }
    preview { Faker::Lorem.paragraph }
    text { Faker::Lorem.paragraph(2, false, 4) }
  end

end
