# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :set_locale, :load_session

  protected

  def login_required
    return true if session[:user]
    add_notice "Please login to continue"
    session[:return_to] = request.request_uri
    redirect_to :controller => 'user', :action => 'register'
    return false
  end

  def admin_required
    @user.admin?
  end

  def find_subdomain_for_language(language)
    LANGUAGE_BY_SUBDOMAIN.index language
  end

  def default_currency_for(locale)
    DEFAULT_CURRENCIES[locale.to_s || 'en']
  end

  def prune(hash)
    hash.delete_if { |k,v| v == '' }
  end

  def add_notice(notice)
    flash[:notice] = notice
    logger.info notice
  end

  def add_error(error)
    flash[:error] = error
    logger.error error
  end

  def add_debug(debug)
    flash[:debug] = debug
    logger.debug debug
  end

  def set_locale
    parsed_locale = LANGUAGE_BY_SUBDOMAIN[request.host.split('.').first]
    if (parsed_locale)
      I18n.locale = LANGUAGE_BY_SUBDOMAIN[parsed_locale]
      logger.info "Locale automagically set to #{parsed_locale}"
    end
  end

  def load_session
    if session[:user]
      begin
        @user = User.find session[:user]
      rescue ActiveRecord::RecordNotFound
        add_error "Could not reload user #{session[:user]} from session"
      end
    end
    if session[:cart]
      begin
        @cart = Cart.find session[:cart]
      rescue ActiveRecord::RecordNotFound
        add_error "Could not reload cart #{session[:cart]} from session"
      end
    end
    if session[:currency]
      begin
        @currency = Currency.find session[:currency]
      rescue ActiveRecord::RecordNotFound
        add_error "Could not reload currency #{session[:currency]} from session"
      end
    end
    unless @currency
      logger.info "Using default currency for #{I18n.locale}"
      session[:currency] = default_currency_for I18n.locale
      logger.info "Using default currency for #{session[:currency]}"
      @currency = Currency.find session[:currency]
    end
  end
end
