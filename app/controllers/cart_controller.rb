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
    logger.debug "************************"+ params[:action]
    if request.post? and params[:aktion] == 'create'
      @order = Order.create @user, @currency, @cart

      @order.shipping_price = 12
      @order.save!

      session[:order_id] = @order.id
      add_debug "Created order ##{@order.id} using data from cart ##{@cart.id}"
    elsif session[:order_id]
      @order = Order.find session[:order_id]
      if request.post? and params[:order]
#      if params[:order][:shipping_address_id] == 'new'
#        redirect_to :controller => 'user', :action => 'new_address'
#      else
#        @order.shipping_address_id = params[:order][:shipping_address_id] if params[:order][:shipping_address_id]
#        @order.shipping_type = params[:order][:shipping_type] if params[:order][:shipping_type]
#        @order.save!
#      end
      end
    else
      add_error "Invalid checkout flow"
      redirect_to :action => 'index'
    end
  end

  def estimate_shipping
    order = Order.find session[:order_id]
    order.ship_to_country = Country.find params[:countryid]
    order.save!
    compute_shipping_to order.ship_to_country, order.currency
  end

  def choose_shipping
    @order = Order.find session[:order_id]
    compute_shipping_to @order.ship_to_country, @order.currency
    case params[:shippingtype]
      when 'ems'
        @order.shipping_price = @ems_price
      when 'sal'
        @order.shipping_price = @sal_price
    end
    @order.save!
  end

  def to_paypal
    order = Order.find session[:order_id]
    response = Paypal::Api.set_express_checkout(order, url_for(:action => 'confirmation'), url_for(:action => 'paypal_cancel'))
    if response.success
      order.paypal_token = response.token
      order.save!
      url = PAYPAL_USER_URL + "&token=#{CGI.escape(response.token)}&useraction=commit"
      redirect_to url
    else
      add_error "Paypal error (1): #{response.error_message} (#{response.error_code})"
      redirect_to :action => 'index'
    end
  end

  def confirmation
    @order = Order.find session[:order_id]
    token = params[:token]
    payer_id = params[:PayerID]
    details = Paypal::Api.get_express_checkout_details(token)
    if details.success
      country = Country.from_paypal_code details.country_code
      @order.payment_type = 'paypal'
      @order.paypal_token = token
      @order.paypal_payer_id = payer_id
      @order.payment_status = 'waiting-for-user-confirmation'
      @order.ship_to_name = details.name
      @order.ship_to_street = details.street
      @order.ship_to_zip = details.zip
      @order.ship_to_city = details.city
      @order.ship_to_state = details.state
      @order.ship_to_country_code = details.country_code
      @order.ship_to_country = country
      @order.save!
      compute_shipping_to country, @order.currency
    else
      add_error "Paypal error (2): #{details.error_message} (#{details.error_code})"
      redirect_to :action => 'index'
    end
  end

  def paypal_cancel
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

  private

  def compute_shipping_to(country, currency)
    @ems_price = nil
    @sal_price = nil
    if country.special?
      logger.info "Special shipping conditions for country ##{country.id}"
      @ems_desc = "Special shipping conditions will apply. Please contact us directly to proceed with your order."
      @sal_desc = @ems_desc
    else
      order = Order.find session[:order_id]
      packer = Packer.new
      items = [ ]
      order.order_items.each do |oi|
        oi.quantity.times { items << oi.item }
      end
      @ems_price = 0
      @sal_price = 0
      @ems_desc = ''
      @sal_desc = ''
      packing = packer.find_optimal_packing items
      logger.info "Zones for country ##{country.id}: ems=#{country.ems_zone} / sal=#{country.sal_zone}"
      packing.each do |pack|
        ems_shipping = ShippingPrice.find_for_package(pack, 'ems', country.ems_zone)
        if ems_shipping
          @ems_price += currency.from_yen(ems_shipping.price)
          @ems_desc += "<p>Package #{pack[:dimensions][0]}x#{pack[:dimensions][1]}x#{pack[:dimensions][2]} of weight #{pack[:weight]} will cost #{currency.format_yen_value(ems_shipping.price)}</p>"
        else
          @ems_price = nil
          @ems_desc = "(EMS unavailable for this country)"
        end
        sal_shipping = ShippingPrice.find_for_package(pack, 'sal', country.sal_zone)
        if sal_shipping
          @sal_price += currency.from_yen(sal_shipping.price)
          @sal_desc += "<p>Package #{pack[:dimensions][0]}x#{pack[:dimensions][1]}x#{pack[:dimensions][2]} of weight #{pack[:weight]} will cost #{currency.format_yen_value(sal_shipping.price)}</p>"
        else
          @sal_price = nil
          @sal_desc = "(SAL unavailable for this country)"
        end
      end
    end
  end

end
