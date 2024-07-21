# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'securerandom'

profile_count = Profile.count

if profile_count > 0
  exit
end

# Definindo o número de perfis que você deseja criar
number_of_profiles = 100

number_of_profiles.times do
  Profile.create(
    username: Faker::Name.unique.name,
    profile_url: "https://github.com/#{SecureRandom.hex(10)}",
    avatar_url: Faker::Internet.url,
    followers_count: Faker::Number.within(range: 0..1_000_000),
    following_count: Faker::Number.within(range: 0..1_000_000),
    stars_count: Faker::Number.within(range: 0..1_000_000),
    year_contributions_count: Faker::Number.within(range: 0..1_000_000),
    location: Faker::Address.city,
    organization_name: Faker::Company.name
  )
end