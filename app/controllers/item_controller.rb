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
      @item.update_attributes! prune(params[:item])
      @item.tracklist = [
              { :original_title => 'チルノのパーフェクトさんすう教室', :title_en => "Cirno's perfect math class", :title_fr => "La classe d'arithmétique de Cirno", :file => 3 },
              { :original_title => '青色のチルノ', :title_en => "Blue Cirno", :title_fr => "Cirno bleue", :file => 4 }
      ]
      @item.save!
      redirect_to :action => 'index', :id => @item
    end
  end
end
