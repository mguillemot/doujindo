class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :item

  validates_inclusion_of :quantity, :in => 1..1000
end
