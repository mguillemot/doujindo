class UserAddress < ActiveRecord::Base
  belongs_to :user
  has_many :orders
end
