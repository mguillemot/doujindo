class CartController < ApplicationController
  before_filter :login_required, :only => :checkout
  before_filter :cart_required
  before_filter :non_empty_cart_required, :except => [ :add ]

  def index
  end

  def add
    item = Item.find params[:id]
    begin
      qty = Integer(params[:op][:quantity])
    rescue ArgumentError
      qty = 0
    end
    if qty > 0
      @cart.add item.id, qty
      add_notice t('alerts.item_added_to_cart', :name => item.title, :qty => qty)
    end
    redirect_to :controller => 'item', :action => 'index', :ident => item.ident
  end

  def remove_one
    @item = @cart.find_by_item_id params[:id].to_i
    if @item.quantity > 1
      @item.quantity -= 1
      @item.save!
    end
  end

  def add_one
    @item = @cart.find_by_item_id params[:id].to_i
    if @item.item.stock > @item.quantity
      @item.quantity += 1
      @item.save!
    end
  end

  def remove_all
    @item = @cart.find_by_item_id params[:id].to_i
    @cart.cart_items.delete @item
    @cart.save!
    if @cart.cart_items.empty?
      add_notice t('alerts.cart_emptied')
    end
  end

  def fix_all
    @cart.items_out_of_stock.each do |item|
      if item.item.stock > 0
        item.quantity = item.item.stock
        item.save!
      else
        @cart.cart_items.delete item
        @cart.save!
      end
    end
  end

  def clear
    @cart.cart_items.destroy_all
    @cart.save!
    add_notice t('alerts.cart_emptied')
    redirect_to :controller => 'home'
  end

  def checkout
    if @cart.items_out_of_stock.empty?
      order = Order.create @user, @currency, @cart
      session[:order_id] = order.id
      add_debug "Created order ##{order.id} using data from cart ##{@cart.id}"
      redirect_to :controller => 'order'
    else
      redirect_to :action => 'index'
    end
  end

  protected

  def cart_required
    if !@cart
      @cart = Cart.new
      if @cart.save
        session[:cart] = @cart.id
        add_debug "Shopping cart id #{@cart.id} created"
      else
        add_error t('alerts.cart_creation_error')
        @cart = nil
      end
    end
    if !@cart
      redirect_to :controller => 'home'
      return false
    end
    return true
  end

  def non_empty_cart_required
    if @cart.cart_items.length == 0
      add_error t('alerts.empty_cart')
      redirect_to :controller => 'home'
      return false
    end
    return true
  end
end
