FactoryGirl.define do
  factory :user, aliases: [:target] do
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
  end
end
