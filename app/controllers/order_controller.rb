class OrderController < ApplicationController
  before_filter :login_required
  before_filter :order_required
  before_filter :pending_order_check, :except => :confirmation
  before_filter :check_items_availability

  def index
    if @order.ship_to_country
      compute_shipping_to @order.ship_to_country, @order.currency
    end
  end

  def choose_country
    @order.ship_to_country = Country.find params[:countryid]
    @order.shipping_type = nil
    @order.notes = @packing_debug
    @order.save!
    compute_shipping_to @order.ship_to_country, @order.currency
  end

  def choose_shipping
    compute_shipping_to @order.ship_to_country, @order.currency
    case params[:shippingtype]
      when 'ems'
        @order.shipping_type = 'ems'
        @order.shipping_price = @ems_price
      when 'sal'
        @order.shipping_type = 'sal'
        @order.shipping_price = @sal_price
    end
    @order.save!
  end

  def to_paypal
    response = Paypal::Api.set_express_checkout(@order, url_for(:action => 'review'), url_for(:action => 'cancel' ))
    if response.success
      @order.paypal_token = response.token
      @order.save!
      url = PAYPAL_USER_URL + "&token=#{CGI.escape(response.token)}" #&useraction=commit"
      redirect_to url
    else
      add_error t('alerts.paypal_error', :stage => '1', :msg => response.error_message, :code => response.error_code)
      redirect_to :action => 'index'
    end
  end

  def review
    token = params[:token]
    payer_id = params[:PayerID]
    details = Paypal::Api.get_express_checkout_details(token)
    if details.success
      if details.token != token || details.token != @order.paypal_token
        add_error t('alerts.paypal_error', :stage => '2b', :msg => t('alerts.paypal_error_wrong_token'), :code => 0)
        redirect_to :action => 'index'
      elsif details.payer_id != payer_id
        add_error t('alerts.paypal_error', :stage => '2c', :msg => t('alerts.paypal_error_wrong_payer_id'), :code => 0)
        redirect_to :action => 'index'
      else
        country = Country.from_paypal_code details.country_code
        @order.payment_type = 'paypal'
        @order.paypal_payer_id = details.payer_id
        @order.payment_status = 'waiting-for-user-confirmation'
        @order.ship_to_name = details.name
        @order.ship_to_street = details.street
        @order.ship_to_zip = details.zip
        @order.ship_to_city = details.city
        @order.ship_to_state = details.state
        @order.ship_to_country_code = details.country_code
        @order.notes = details.note
        if @order.ship_to_country != country
          @paypal_alternative_country = country
        end
        @order.save!
      end
    else
      add_error t('alerts.paypal_error', :stage => '2a', :msg => details.error_message, :code => details.error_code)
      redirect_to :action => 'index'
    end
  end

  def recompute_shipping
    @order.ship_to_country = Country.from_paypal_code @order.ship_to_country_code
    @paypal_alternative_country = nil
    compute_shipping_to @order.ship_to_country, @order.currency
    case @order.shipping_type
      when 'ems'
        @order.shipping_price = @ems_price
      when 'sal'
        @order.shipping_price = @sal_price
    end
    @order.save!
  end

  def cancel
    add_notice t('alerts.paypal_cancelled')
    @order.payment_status = 'cancelled-by-user'
    @order.save!
    redirect_to :action => 'index'
  end

  def confirmation
    response = Paypal::Api.do_express_checkout_payment(@order.paypal_token, @order.paypal_payer_id, @order.total_price, @order.currency)
    if response.success
      @order.decrease_stocks!
      @order.payment_status = 'paid'
      @order.payment_date = DateTime.now
      @order.paypal_transaction_id = response.transaction_id
      @order.save!
      @cart.empty!
      begin
        Notifier.deliver_order_confirmation(@order)
      rescue
        add_notice t('alerts.impossible_to_send_order_confirm_mail', :email => @user.email)
      end
    else
      @order.payment_status = "paypal-error ##{response.reason_code}"
      @order.save!
      add_error t('alerts.paypal_error', :stage => '3', :msg => response.error_message, :code => response.error_code)
      redirect_to :action => 'index'
    end
  end

  protected

  def order_required
    @order = Order.find session[:order_id]
    unless @order
      redirect_to :controller => 'cart' unless @order
      return false
    end
    return true
  end

  def pending_order_check
    if @order.payment_status == 'paid'
      add_notice t('alerts.order_already_confirmed')
      redirect_to :controller => 'home'
      return false
    end
    return true
  end

  def check_items_availability
    @order.order_items.each do |oi|
      if oi.item.stock < oi.quantity
        redirect_to :controller => 'cart', :action => 'index'
        return false
      end
    end
    return true
  end

  def compute_shipping_to(country, currency)
    @ems_price = nil
    @sal_price = nil
    if country.special?
      logger.info "Special shipping conditions for country ##{country.id}"
      @ems_desc = t('user.orders.detail.delivery.special')
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
      @packing_price = 0
      @ems_desc = ''
      @sal_desc = ''
      packing = packer.find_optimal_packing items
      logger.info "Zones for country ##{country.id}: ems=#{country.ems_zone} / sal=#{country.sal_zone}"
      packing.each do |pack|
        # Packing prices
        # TODO: business rules for packing prices
        if pack[:type] == 'box' and pack[:dimensions][0] <= 150 and pack[:dimensions][1] <= 150 and pack[:dimensions][2] <= 30 and pack[:weight] <= 500
          @packing_debug = "petite enveloppe papier bulle"
          @packing_price += 100
        elsif pack[:type] == 'box' and pack[:dimensions][0] <= 200 and pack[:dimensions][1] <= 200 and pack[:dimensions][2] <= 40 and pack[:weight] <= 1000
          @packing_debug = "grande enveloppe papier bulle"
          @packing_price += 150
        elsif pack[:type] == 'box' and pack[:dimensions][0] <= 400 and pack[:dimensions][1] <= 400 and pack[:dimensions][2] <= 300
          @packing_debug = "petit carton"
          @packing_price += 200
        elsif pack[:type] == 'box' and pack[:dimensions][0] <= 600 and pack[:dimensions][1] <= 600 and pack[:dimensions][2] <= 450
          @packing_debug = "grand carton"
          @packing_price += 250
        else
          @packing_debug = "other"
          @packing_price += 250
        end
        @packing_debug = "Packing: (#{pack[:dimensions][0]}x#{pack[:dimensions][1]}x#{pack[:dimensions][2]}) weight #{pack[:weight]} => #{@packing_debug} for total price #{@packing_price}"
        logger.info @packing_debug

        # Shipping prices
        ems_shipping = ShippingPrice.find_for_package(pack, 'ems', country.ems_zone)
        if ems_shipping
          @ems_price += ems_shipping.price
        end
        sal_shipping = ShippingPrice.find_for_package(pack, 'sal', country.sal_zone)
        if sal_shipping
          @sal_price += sal_shipping.price
        end
      end

      # Converting currencies
      if @ems_price > 0
        @ems_price += @packing_price
        @ems_price = currency.from_yen(@ems_price)
        @ems_desc = currency.format_value(@ems_price)
      else
        @ems_desc = t('user.orders.detail.delivery.ems_unavailable')
      end
      if @sal_price > 0
        @sal_price += @packing_price
        @sal_price = currency.from_yen(@sal_price)
        @sal_desc = currency.format_value(@sal_price)
      else
        @sal_desc = t('user.orders.detail.delivery.sal_unavailable')
      end
    end
  end
end
