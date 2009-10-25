class SessionCart
  def initialize
    @items = [ ]
  end

  def add(item_id, quantity)
    @items << { :item_id => item_id, :quantity => quantity }
  end

  def items
    @items
  end
end