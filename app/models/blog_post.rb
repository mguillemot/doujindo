class BlogPost < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'

  translatable_columns :title, :content
  validates_translation_of :title, :content
end
