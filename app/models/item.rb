class Item < ActiveRecord::Base
  belongs_to :category

  translatable_columns :title, :author, :item_type, :description, :publisher, :tracklist, :test, :required_config, :format, :warning, :notes
  validates_translation_of :title, :author, :item_type, :description

  def nav
    category.nav << [ title, { :controller => 'item', :action => 'index', :id => id } ]
  end

  def max_order
    max = 0
    if stock_left != nil && stock_left > 0
      max += stock_left
    elsif purchase_left != nil && purchase_left > 0
      max += purchase_left
    elsif reservation_left != nil && reservation_left > 0
      max += reservation_left
    end
    max
  end

  def stock_display
    if stock_left != nil && stock_left > 0
      additional = (purchase_left != nil && purchase_left > 0) ? " / additional #{purchase_left} available within 3 days" : ""
      "ships within 24 hours (stock: #{stock_left})#{additional}"
    elsif purchase_left != nil && purchase_left > 0
      "ships within 3 days (stock: #{purchase_left})"
    elsif reservation_left != nil && reservation_left > 0
      "can be preordered until #{reservation_end_date} (stock: #{reservation_left})"
    else
      "not available"
    end
  end
end
