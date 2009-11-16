class UserAddress < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  belongs_to :country

  validates_size_of :full_address, :minimum => 30
end
