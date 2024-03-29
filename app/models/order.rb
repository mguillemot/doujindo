class
Order < ActiveRecord::Base
  has_many :order_items, :dependent => :destroy
  belongs_to :client, { :class_name => 'User' }
  belongs_to :currency
  belongs_to :ship_to_country, { :class_name => 'Country' }
  belongs_to :shipping_calculated_for_country, { :class_name => 'Country' }

  def total_price
    total = items_total_price
    total += shipping_price if shipping_price
    total
  end

  def status
    if payment_status == 'paid' and shipping_status == 'sent'
      'sent'
    else
      'paid'
    end
  end

  def decrease_stocks!
    order_items.each do |oi|
      oi.item.stock -= oi.quantity
      oi.item.save!
    end
  end

  def self.create(user, currency, cart)
    order = Order.new
    order.client = user
    order.currency = currency
    order.items_total_price = cart.total_price_in(currency)
    order.payment_status = 'choose-payment'
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
