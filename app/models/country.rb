class Country < ActiveRecord::Base
  has_many :user_addresses

  translatable_columns :name
end
