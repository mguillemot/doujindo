class UserController < ApplicationController
  before_filter :login_required, :only => [ :index, :orders, :order, :logout ]
  before_filter :login_refused, :only => [ :register, :login ]

  def index
  end

  def change_language
    if @user
      @user.preferred_language = params[:id]
      @user.save!
    end

    # redirect to the proper site
    begin
      uri = URI.parse request.referer
      parts = uri.host.split '.'
      parts[0] = find_subdomain_for_language(params[:id]) || 'www'
      uri.host = parts.join '.'
      redirect_to uri.to_s
    rescue URI::InvalidURIError
      logger.error "Impossible to redirect to #{request.referer} after language switch to #{params[:id]}"
      redirect_to :controller => 'home'
    end
  end

  def change_currency
    session[:currency] = params[:id]
    if @user
      @user.preferred_currency = params[:id]
      @user.save!
    end
    redirect_to request.referer
  end

  def orders
    @orders = @user.orders.find_all_by_payment_status 'paid'
  end

  def order
    @order = @user.orders.find_by_id params[:id]
    if @order.client != @user or @order.payment_status != 'paid'
      add_error t('alerts.invalid_order')
      redirect_to :action => 'orders'
    end
  end

  def login
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        user.login_count += + 1
        user.last_login = DateTime.now
        user.save!
        session[:user] = user.id
        session[:currency] = user.preferred_currency || default_currency_for(user.preferred_language)
        logger.info "User #{user.id} logged successfully with preferred language '#{user.preferred_language}' (vs. '#{I18n.locale}') and currency '#{user.preferred_currency}' (vs. '#{session[:currency]}')"
        if (user.preferred_language && I18n.locale != user.preferred_language)
          logger.info "User-defined language is not the same as current language: switch!"
          begin
            parts = request.host.split('.')
            parts[0] = find_subdomain_for_language(user.preferred_language) || 'www'
            lang_host = parts.join('.')
            redirect_to :controller => 'user', :action => 'index', :host => lang_host, :port => request.port
          rescue URI::InvalidURIError
            logger.error "Impossible to redirect to #{request.referer} after language switch to #{params[:id]}"
            redirect_to controller => 'user', :action => 'index'
          end
        else
          redirect_to :controller => 'user', :action => 'index'
        end
      else
        add_error t('alerts.login_failure')
        redirect_to request.referer
      end
    end
  end

  def logout
    session[:user] = nil
    add_notice "Logged out"
    redirect_to :controller => 'home'
  end

  def register
    if request.post? and params[:user]
      @user = User.new params[:user]
      @user.regen_confirmation_key
      @user.preferred_language = I18n.locale.to_s
      @user.preferred_currency = @currency.id
      if @user.save
        session[:user] = @user.id
        Notifier.deliver_registration_confirmation_request @user
        add_notice t('alerts.confirmation_email_sent', {:email => @user.email})
        redirect_to :action => 'index'
      else
        add_error t('alerts.registration_error')
        @user.password = ''
        @user.password_confirmation = ''
      end
    end
  end

  def confirm_email
    user = User.find_by_email_confirmation_key params[:id]
    if user and user.email_confirmation_date.nil?
      user.email_confirmation_date = DateTime.now
      user.save!
      Notifier.deliver_registration_final_confirmation user
      add_notice t('alerts.validation_email_sent', {:email => user.email})
      if @user and @user.id == user.id
        redirect_to :action => 'index'
        return
      end
    end
    redirect_to :controller => 'home'
  end

  protected

  def do_login
    # TODO factoriser ici le login après inscription et le login "normal"
  end

end
