class BlogController < ApplicationController
  before_filter :admin_required, :only => :new

  def index
    @posts = BlogPost.find :all, :order => 'created_at DESC', :limit => 8
  end

  def view
    if params[:ident]
      @post = BlogPost.find_by_ident params[:ident]
    elsif params[:id]
      @post = BlogPost.find_by_id params[:id]
    end
    if @post == nil
      add_error t('alerts.invalid_blog_post')
      redirect_to :controller => 'home'
    end
  end

  def new
    if request.post? and params[:post]
      @post = BlogPost.new params[:post]
      if @post.save
        redirect_to :action => 'index'
      else

      end

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
    else
      @post = BlogPost.new
    end
  end
end
