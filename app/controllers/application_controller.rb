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
    add_notice t('alerts.please_login')
    session[:return_to] = request.request_uri
    logger.info "Set session return-to to \"#{session[:return_to]}\""
    redirect_to :controller => 'user', :action => 'register'
    return false
  end

  def login_refused
    return true unless session[:user]
    add_notice t('alerts.please_logout')
    redirect_to :controller => 'home'
    return false
  end

  def admin_required
    return true if admin?
    add_notice t('alerts.admin_only')
    redirect_to :controller => 'home'
    return false
  end

  def admin?
    @user != nil && @user.admin?
  end

  def find_subdomain_for_language(language)
    LANGUAGE_BY_SUBDOMAIN.index language
  end

  def default_currency_for(locale)
    DEFAULT_CURRENCIES[locale.to_s || 'en']
  end

  def prune(hash)
    hash.delete_if { |k, v| v == '' }
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
    if admin?
      flash[:debug] = debug
    end
    logger.debug debug
  end

  def add_notice_now(notice)
    flash.now[:notice] = notice
    logger.info notice
  end

  def add_error_now(error)
    flash.now[:error] = error
    logger.error error
  end

  def add_debug_now(debug)
    if admin?
      flash.now[:debug] = debug
    end
    logger.debug debug
  end

  def set_locale
    parsed_locale = LANGUAGE_BY_SUBDOMAIN[request.host.split('.').first]
    if parsed_locale
      I18n.locale = LANGUAGE_BY_SUBDOMAIN[parsed_locale]
    end
  end

  def load_session
    if session[:user]
      begin
        @user = User.find session[:user]
      rescue ActiveRecord::RecordNotFound
        add_error t('alerts.user_reload_failed')
        logger.error "Could not reload user #{session[:user]} from session"
        session[:user] = nil
      end
    end
    if session[:cart]
      begin
        @cart = Cart.find session[:cart], :include => :cart_items
      rescue ActiveRecord::RecordNotFound
        add_error t('alerts.cart_reload_failed')
        logger.error "Could not reload cart #{session[:cart]} from session"
        session[:cart] = nil
      end
    end
    if session[:currency]
      begin
        @currency = Currency.find session[:currency]
      rescue ActiveRecord::RecordNotFound
        logger.error "Could not reload currency #{session[:currency]} from session"
      end
    end
    unless @currency
      session[:currency] = default_currency_for I18n.locale
      logger.info "Using default currency for #{I18n.locale} which is #{session[:currency]}"
      @currency = Currency.find session[:currency]
    end
  end
end
