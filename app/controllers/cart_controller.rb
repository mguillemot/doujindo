class CartController < ApplicationController
  before_filter :cart_required

  def index
  end

  def add
    begin
      qty = Integer(params[:op][:quantity])
    rescue ArgumentError
      qty = 0
    end
    if qty < 0
      qty = 0
    end
    @cart.add params[:id], qty
    add_notice "Item #{params[:id]} x#{qty} added to cart"
    redirect_to :controller => 'item', :action => 'index', :id => params[:id]
  end

  def remove_one
    @item = @cart.cart_items.find_by_item_id params[:id]
    @item.quantity -= 1
    @item.save!
  end

  def add_one
    @item = @cart.cart_items.find_by_item_id params[:id]
    @item.quantity += 1
    @item.save!
  end

  def remove_all
    @item = @cart.cart_items.find_by_item_id params[:id]
    @cart.cart_items.delete @item
    @cart.save!
    #TODO @item.destroy
  end

  def checkout
  end

  protected

  def cart_required
    if !@cart
      @cart = Cart.new
      if @cart.save
        session[:cart] = @cart.id
        add_debug "Shopping cart id #{@cart.id} created"
      else
        add_error "Impossible to create a new shopping cart"
        @cart = nil
      end
    end
    if !@cart
      redirect_to :controller => 'home'
      return false
    end
    return true
  end
end
