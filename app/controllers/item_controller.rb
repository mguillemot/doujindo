class ItemController < ApplicationController
  before_filter :admin_required, :only => :edit

  def index
#    if params[:id] =~ /\d+/
    @item = Item.find_by_id params[:id]
#    else
#      @item = Item.find_by_ident params[:id]
#    end
    if @item == nil or (@item.show? == false and admin? == false)
      add_error "Invalid item ##{params[:id]}"
      redirect_to :controller => 'home'
    end
  end

  def edit
    @item = Item.find params[:id]
    if request.post? and params[:item]
      logger.debug params[:item][:title_fr].class
      logger.debug prune(params[:item])[:title_fr].class
      @item.update_attributes! prune(params[:item])
      redirect_to :action => 'index', :id => @item
    end
  end
end
