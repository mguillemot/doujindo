class StockType
  AVAILABLE_NOW = 'availableNow'
  CAN_BE_PURCHASED = 'canBePurchased'
  RESERVATION = 'reservation'
  UNAVAILABLE = 'unavailable'
end

class Item < ActiveRecord::Base
  belongs_to :category

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'show', :id => id } ]
  end

  def stock_display
    case stock_type
      when StockType::AVAILABLE_NOW
        "ships within 24 hours (stock: #{current_stock})"
      when StockType::CAN_BE_PURCHASED
        "ships within 3 days (max: #{max_purchase})"
      when StockType::RESERVATION
        "can be preordered until #{reservation_end}"
      when StockType::UNAVAILABLE
        "not available"
    end
  end
end
