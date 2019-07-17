source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'rails', '~> 6.0.0.rc1'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'responders'
gem 'faker'
gem 'fast_jsonapi'
gem 'will_paginate'
gem 'api-pagination'
gem 'jwt'
gem 'bcrypt'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'shoulda-matchers', '~> 4.1.0'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.8'
end
