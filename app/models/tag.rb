class Tag < ActiveRecord::Base
  has_and_belongs_to_many :items, :join_table => 'item_tags'

  translatable_columns :title
end
