class CartItem < ActiveRecord::Base
  belongs_to :cart

  validates_inclusion_of :quantity, :in => 1..1000

  def item
    Item.find item_id
  end
end
