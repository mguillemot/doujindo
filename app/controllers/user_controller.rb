class UserController < ApplicationController
  before_filter :login_required, :only => ['home']

  def home
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
            redirect_to :controller => 'user', :action => 'home', :host => lang_host, :port => request.port 
          rescue URI::InvalidURIError
            logger.error "Impossible to redirect to #{request.referer} after language switch to #{params[:id]}"
            redirect_to controller => 'user', :action => 'home'
          end
        else
          redirect_to :controller => 'user', :action => 'home'
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
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        add_notice "User #{@user.login} created!"
        redirect_to :action => 'home'
      else
        add_error "Registration error"
        @user.password = '';
        @user.password_confirmation = '';
      end
    end
  end

end
