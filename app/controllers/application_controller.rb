# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :get_logged_user_and_cart

  def login_required
    return true if session[:user]
    add_notice "Please login to continue"
    session[:return_to] = request.request_uri
    redirect_to :controller => 'user', :action => 'register'
    return false
  end

  def add_notice(notice)
#    if flash[:notice]
#      flash[:notice] += '<br />' + notice
#    else
      flash[:notice] = notice
#    end
  end

  def add_error(error)
#    if flash[:error]
#      flash[:error] += '<br />' + error
#    else
      flash[:error] = error
#    end
  end

  def add_debug(debug)
#    if flash[:debug]
#      flash[:debug] += '<br />' + debug
#    else
      flash[:debug] = debug
#    end
  end

  def get_logged_user_and_cart
    if session[:user]
      begin
        @user = User.find session[:user]
        @cart = @user.cart
      rescue ActiveRecord::RecordNotFound
        add_error "Could not reload user #{session[:user]}"
      end
    end
    if !@cart and session[:cart] # We have a floating cart
      begin
        @cart = Cart.find session[:cart]
      rescue ActiveRecord::RecordNotFound
        add_error "Could not reload cart #{session[:cart]}"
      end
    end
  end
end
