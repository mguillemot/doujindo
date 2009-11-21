class Cart < ActiveRecord::Base
  has_many :cart_items, :dependent => :destroy

  def empty
    cart_items.destroy_all
  end

  def total_price_in(currency)
    total = 0
    cart_items.each do |item|
      total += item.quantity * currency.from_yen(item.item.price)
    end
    total
  end

  def add(item_id, quantity)
    existing_item = cart_items.find_by_item_id item_id
    if (existing_item)
      existing_item.quantity += quantity
      existing_item.save
    else
      cart_items.create :item_id => item_id, :quantity => quantity
    end
  end
end
