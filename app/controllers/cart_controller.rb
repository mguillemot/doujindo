class CartController < ApplicationController
  before_filter :cart_required

  def index
    @title = "Shopping cart summary"
    @nav = [ [ 'Shopping cart' ] ]
  end

  def add
    @cart.add params[:id], 1
    add_notice "Item #{params[:id]} added to cart"
    redirect_to :controller => 'item', :action => 'show', :id => params[:id]
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

  def clear
    @cart.cart_items.destroy_all
    @cart.save!
    redirect_to :controller => 'home' # TODO r�ussir � revenir sur la page courante
  end

  def checkout
  end

  protected

  def cart_required
    if !@cart
      if @user
        @cart = @user.cart.create
      else
        @cart = Cart.new
      end
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