class Order < ActiveRecord::Base
  has_many :order_items, :dependent => :destroy
  belongs_to :client, { :class_name => 'User' }
  belongs_to :currency
  belongs_to :ship_to_country, { :class_name => 'Country' }

  def self.create(user, currency, cart)
    order = Order.new
    order.client = user
    order.currency = currency
    order.items_total_price = cart.total_price_in(currency)
    order.save!
    cart.cart_items.each do |item|
      price = currency.from_yen(item.item.price)
      order.order_items.create(
              :item => item.item,
              :quantity => item.quantity,
              :unit_price => price,
              :total_price => price * item.quantity
              )
    end
    order
  end
end
