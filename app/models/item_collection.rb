class ItemCollection < ActiveRecord::Base
  has_many :items

  translatable_columns :title
  validates_translation_of :title
end
