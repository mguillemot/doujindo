class FaqEntry < ActiveRecord::Base
  acts_as_tree :order => 'display_order'
  translatable_columns :toc_entry, :question, :answer
end
