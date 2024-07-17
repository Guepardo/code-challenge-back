FactoryBot.define do
  factory :profile do
    username { Faker::Name.unique.name }
    profile_url { "https://github.com/#{username.downcase.tr(' ', '-')}" }
    avatar_url { Faker::Internet.url }
    fallowers_count { Faker::Number.within(range: 0..100) }
    fallowing_count { Faker::Number.within(range: 0..100) }
    stars_count { Faker::Number.within(range: 0..100) }
    year_contributions_count { Faker::Number.within(range: 0..100) }
    location { Faker::Address.city }
    organization_name { Faker::Company.name }
  end
end
