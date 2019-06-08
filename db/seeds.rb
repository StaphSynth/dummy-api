require 'faker'

20.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.phone_number
  )
end

USERS = User.all

150.times do
  Post.create!(
    user_id: USERS.sample.id,
    title: Faker::Hacker.say_something_smart,
    body: Faker::Lorem.sentences(rand(10..35)).join(' ')
  )
end
