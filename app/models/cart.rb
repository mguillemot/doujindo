class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :cart_items, :dependent => :destroy

  validates_associated :cart_items

  def total_price
    total = 0
    cart_items.each do |item|
      total += item.quantity * item.item.price
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
