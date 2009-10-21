class UserController < ApplicationController
  before_filter :login_required, :only => ['home']

  def home
    @title = "User home"
    @user = User.find(session[:user]);
  end

  def login
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        session[:user] = user.id
        flash[:notice] = "Login successful"
        redirect_to :controller => 'user', :action => 'home'
      else
        flash[:error] = "Login failure"
        redirect_to :controller => 'home'
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:notice] = "Logged out"
    redirect_to :controller => 'home'
  end

  def register
    @title = "Registration"
    if request.post? and params[:user]
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        flash[:notice] = "User #{@user.login} created!"
        redirect_to :action => 'home'
      else
        flash[:error] = "Registration error"
        @user.password = '';
        @user.password_confirmation = '';
      end
    end
  end
end
