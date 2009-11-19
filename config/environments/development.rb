# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs = true
config.action_controller.perform_caching = false

# Mailer
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
        :address => 'smtp.touhou-shop.com',
        :domain => '127.0.0.1',
        :port => 5025,
        :user_name => 'postmaster@touhou-shop.com',
        :password => 'Ez3p7f8gAt2N',
        :authentication => :login
}
config.action_mailer.default_charset = 'utf-8'

# Cookies
DOMAIN = 'touhou-local.com'

# Sitemap
STATIC_ROOT_URL = 'http://static.touhou-local.com/static-touhou-shop'

# PayPal
PAYPAL_API_URL = 'https://api-3t.sandbox.paypal.com/nvp'
PAYPAL_USER_URL = 'https://www.sandbox.paypal.com/webscr&cmd=_express-checkout'
PAYPAL_USER = 'payment_api1.touhou-shop.com'
PAYPAL_PWD = 'KN6K3KLXBDQTLHQ3'
PAYPAL_SIGNATURE = 'AbGhBFISPjSS9ZCvaXavWffxEvTzA28ZuQSusINMThFA7UKPV.QVZIXY'
