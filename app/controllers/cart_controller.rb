require "paypal/api"

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
    if @cart.cart_items.empty?
      add_notice t('alerts.cart_emptied')
    end
  end

  def clear
    @cart.cart_items.destroy_all
    @cart.save!
    add_notice t('alerts.cart_emptied')
    redirect_to :controller => 'home'
  end

  def checkout
    if request.post? and params[:order]
      @order = Order.find params[:order][:id]
      if @order.client != @user
        raise(SecurityError, 'Attempt to access an order from another client')
      end
      logger.debug "id=" + params[:order].inspect
      if params[:order][:shipping_address_id] == 'new'
        redirect_to :controller => 'user', :action => 'new_address'
      else
        @order.shipping_address_id = params[:order][:shipping_address_id] if params[:order][:shipping_address_id]
        @order.shipping_type = params[:order][:shipping_type] if params[:order][:shipping_type]
        @order.save!
      end
    else
      @order = Order.create @user, @currency, @cart
      add_debug "Created order ##{@order.id} using data from cart ##{@cart.id}"
    end
  end

  def test_payment
    response = Paypal::Api.set_express_checkout(420, @currency, url_for(:action => 'test_return'), url_for(:action => 'test_cancel'))
    logger.debug "999999999999"+response.inspect
    if response.success
      url = PAYPAL_USER_URL + "&token=#{CGI.escape(response.token)}"
      @display = "<p><a href=\"#{url}\">#{url}</a></p>"
      # adresse de retour: http://www.touhou-shop.com/cart/test_return?token=EC-7X287919VE028510J&PayerID=WXDNBJYQG85QN
    else
      @display = "Paypal error: #{response.error_message} (#{response.error_code})"
    end
  end

  def test_return
    @token = params[:token]
    @payer_id = params[:PayerID]
    details = Paypal::Api.get_express_checkout_details(@token)
    @display = '<p>' + details.inspect + '</p>'
    payment = Paypal::Api.do_express_checkout_payment(@token, @payer_id, 1000, @currency)
    @display += '<p>' + payment.inspect + '</p>'
  end

  def test_cancel
    @token = params[:token]
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
