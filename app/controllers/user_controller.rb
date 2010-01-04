class UserController < ApplicationController
  before_filter :login_required, :only => [ :index, :orders, :order, :logout ]
  before_filter :login_refused, :only => [ :register, :confirm_email, :forgot_password, :reset_password, :login ]

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
    if request.post? and params[:user][:login] and params[:user][:password]
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        do_login user
      else
        add_error t('alerts.login_failure')
        redirect_to request.referer
      end
    else
      redirect_to :controller => 'home'
    end
  end

  def logout
    session[:user] = nil
    add_notice t('alerts.logged_out')
    redirect_to :controller => 'home'
  end

  def register
    @user = User.new
    if request.post? and params[:user]
      @user = User.new params[:user]
      @user.regen_confirmation_key
      @user.preferred_language = I18n.locale.to_s
      @user.preferred_currency = @currency.id
      if @user.save
        Notifier.deliver_registration_confirmation_request @user
        add_notice t('alerts.confirmation_email_sent', :email => @user.email, :login => @user.login)
        do_login @user
      else
        add_error t('alerts.registration_error')
        @user.password = ''
        @user.password_confirmation = ''
      end
    end
  end

  def forgot_password
    @email = ''
    if request.post? and params[:email]
      @email = params[:email]
      user = User.find_by_email params[:email]
      if user
        user.lost_password_key = Utils.random_string(16)
        user.lost_password_date = DateTime.now
        user.save!
        Notifier.deliver_password_forgotten user
        add_notice_now t('alerts.forgotten_password_email_sent', :email => user.email)
      else
        add_error_now t('alerts.forgotten_password_no_such_email')
      end
    end
  end

  def reset_password
    @user = User.find_by_lost_password_key params[:id]
    if @user
      minutes_ago = (Time.now - @user.lost_password_date)/1.minute
      if minutes_ago > 30
        logger.info "Operation expired: generated #{minutes_ago} minutes ago"
        add_error t('alerts.reset_password_expired_key')
        @user = nil
        redirect_to :controller => 'user', :action => 'forgot_password'
      else
        if request.post? and params[:password] and params[:password] == params[:password_confirmation]
          @user.password = params[:password]
          @user.save!
          add_notice t('alerts.reset_password_ok')
          do_login @user
        end
      end
    else
      add_error t('alerts.reset_password_invalid_key')
      redirect_to :controller => 'user', :action => 'forgot_password'
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

  def do_login(user)
    user.login_count += 1
    user.last_login = DateTime.now
    user.save!
    session[:user] = user.id
    logger.info "User #{user.id} logged successfully with preferred language '#{user.preferred_language}' (vs. '#{I18n.locale}') and currency '#{user.preferred_currency}' (vs. '#{session[:currency]}')"
    logger.info "Referer was \"#{request.referer}\", session return-to was \"#{session[:return_to]}\""
    redirect = session[:return_to] || request.referer
    session[:return_to] = nil
    session[:currency] = user.preferred_currency || default_currency_for(user.preferred_language)
    if user.preferred_language != nil and I18n.locale.to_s != user.preferred_language
      logger.info "User-defined language is not the same as current language: switch!"
      begin
        redirect = URI.parse(redirect)
        parts = redirect.host.split('.')
        parts[0] = find_subdomain_for_language(user.preferred_language) || 'www'
        redirect.host = parts.join('.')
        redirect_to redirect.to_s
      rescue URI::InvalidURIError
        logger.error "Impossible to redirect to #{redirect} after language switch to #{params[:id]}"
        redirect_to redirect
      end
    else
      redirect_to redirect
    end
  end

end
