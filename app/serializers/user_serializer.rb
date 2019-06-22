class UserSerializer < ApplicationSerializer
  attributes :id, :name, :email, :phone_number, :created_at, :updated_at

  has_many :posts
end
