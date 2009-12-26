class Osusume < ActiveRecord::Base
  belongs_to :item

  translatable_columns :reason
end
