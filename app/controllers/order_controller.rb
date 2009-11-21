class OrderController < ApplicationController
  before_filter :order_required

  def index
    if @order.ship_to_country
      compute_shipping_to @order.ship_to_country, @order.currency
    end
  end

  def choose_country
    @order.ship_to_country = Country.find params[:countryid]
    @order.shipping_type = nil
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
      url = PAYPAL_USER_URL + "&token=#{CGI.escape(response.token)}&useraction=commit"
      redirect_to url
    else
      add_error "Paypal error (1): #{response.error_message} (#{response.error_code})"
      redirect_to :action => 'index'
    end
  end

  def review
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

  def cancel
    @token = params[:token]
  end

  def confirmation
    response = Paypal::Api.do_express_checkout_payment(@order.paypal_token, @order.paypal_payer_id, @order.total_price, @order.currency)
    if response.success
      @order.payment_status = 'paid'
      @order.payment_date = DateTime.now
      @order.paypal_transaction_id = response.transaction_id
      @order.save!
      @cart.empty
      Notifier.deliver_order_confirmation(@order)
    else
      @order.payment_status = "paypal-error ##{response.reason_code}"
      @order.save!
      add_error "Paypal error (3): #{response.error_message} (#{response.error_code})"
      redirect_to :action => 'index'
    end
  end

  protected

  def order_required
    @order = Order.find session[:order_id]
    true
  end

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
