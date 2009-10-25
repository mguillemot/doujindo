class Item < ActiveRecord::Base
  belongs_to :category
  has_many :details, :class_name => 'ItemDetail'

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'show', :id => id } ]
  end
end
