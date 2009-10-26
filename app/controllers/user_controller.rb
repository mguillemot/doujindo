class UserController < ApplicationController
  before_filter :login_required, :only => ['home']

  def home
    @title = "User home"
  end

  def login
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        user.login_count = user.login_count + 1
        user.last_login = DateTime.now
        if !user.cart and @cart # We have a floating cart => attach it to the user
          user.cart = @cart
          add_debug "Cart reattached to user"
        end
        user.save!  # Do not validate user, because it has no password at this point
        session[:user] = user.id
        add_notice "Login successful"
        redirect_to :controller => 'user', :action => 'home'
      else
        add_error "Login failure"
        redirect_to :controller => 'home'
      end
    end
  end

  def logout
    session[:user] = nil
    add_notice "Logged out"
    redirect_to :controller => 'home'
  end

  def register
    @title = "Registration"
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
