class Currency < ActiveRecord::Base
  translatable_columns :description, :format
  validates_translation_of :description, :format
end
