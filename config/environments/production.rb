# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

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

# Enable threaded mode
# config.threadsafe!

# Cookies
DOMAIN = 'touhou-shop.com'

# Sitemap
STATIC_ROOT_PATH = 'C:/erhune/touhou-shop-static'
STATIC_ROOT_URL = 'http://static.touhou-shop.com'

# PayPal
PAYPAL_API_URL = 'https://api-3t.paypal.com/nvp'
PAYPAL_USER_URL = 'https://www.paypal.com/webscr&cmd=_express-checkout'
PAYPAL_USER = 'payment_api1.touhou-shop.com'
PAYPAL_PWD = 'BPCBELRA6GB5MYJK'
PAYPAL_SIGNATURE = 'AFcWxV21C7fd0v3bYYYRCpSSRl31AYWi88AQpbLExmH4rsXaoTubq0Jz'
