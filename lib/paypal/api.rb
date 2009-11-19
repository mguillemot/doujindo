module Paypal
  class Api
    def self.set_express_checkout(amount, currency, return_url, cancel_url)
      call = ApiCall.new
      call.add_param 'USER', PAYPAL_USER
      call.add_param 'PWD', PAYPAL_PWD
      call.add_param 'SIGNATURE', PAYPAL_SIGNATURE
      call.add_param 'METHOD', 'SetExpressCheckout'
      call.add_param 'VERSION', '56.0'
      call.add_param 'PAYMENTACTION', 'Sale'
      #call.add_param 'NOSHIPPING', '1'
      call.add_param 'LOCALECODE', (I18n.locale == 'fr') ? 'FR' : 'US'
      call.add_param 'AMT', '%.2f' % amount
      call.add_param 'CURRENCYCODE', currency.paypal_code
      call.add_param 'RETURNURL', return_url
      call.add_param 'CANCELURL', cancel_url
      call.send_request
      SetExpressCheckout.new call.response
    end

    def self.get_express_checkout_details(token)
      call = ApiCall.new
      call.add_param 'USER', PAYPAL_USER
      call.add_param 'PWD', PAYPAL_PWD
      call.add_param 'SIGNATURE', PAYPAL_SIGNATURE
      call.add_param 'METHOD', 'GetExpressCheckoutDetails'
      call.add_param 'VERSION', '56.0'
      call.add_param 'TOKEN', token
      call.send_request
      GetExpressCheckoutDetails.new call.response
    end

    def self.do_express_checkout_payment(token, payer_id, amount, currency)
      call = ApiCall.new
      call.add_param 'USER', PAYPAL_USER
      call.add_param 'PWD', PAYPAL_PWD
      call.add_param 'SIGNATURE', PAYPAL_SIGNATURE
      call.add_param 'METHOD', 'DoExpressCheckoutPayment'
      call.add_param 'VERSION', '56.0'
      call.add_param 'PAYMENTACTION', 'Sale'
      call.add_param 'TOKEN', token
      call.add_param 'PAYERID', payer_id
      call.add_param 'AMT', '%.2f' % amount
      call.add_param 'CURRENCYCODE', currency.paypal_code
      call.send_request
      DoExpressCheckoutPayment.new call.response
    end
  end
end