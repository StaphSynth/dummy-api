require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user_##{n}@example.com" }
    phone_number { Array.new(10) { rand(10) }.join }
  end

  factory :post do
    association :user
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.sentences(rand(10..35)).join(' ') }
  end
end
