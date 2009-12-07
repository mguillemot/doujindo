class BlogController < ApplicationController
  before_filter :admin_required, :only => [ :new, :delete ]

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
      @post.author = @user
      if @post.save
        add_notice "New post added successfully"
        redirect_to :action => 'index'
      end
    else
      @post = BlogPost.new
      @post.ident = Utils.random_string(16)
    end
  end

  def edit
    @post = BlogPost.find params[:id]
    if request.post? and params[:post]
      if @post.update_attributes(params[:post])
        add_notice "Post edited successfully"
        redirect_to :action => 'index'
      end
    end
  end

  def delete
    @post = BlogPost.find params[:id]
    @post.destroy
    add_notice "Post '#{@post.title}' deleted"
    redirect_to :action => 'index'
  end
end
