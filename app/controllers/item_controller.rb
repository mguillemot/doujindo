class ItemController < ApplicationController
  before_filter :admin_required, :except => [ :index, :search ]
  layout :admin_layout

  MAX_RESULTS = 20

  def index
    if params[:ident]
      @item = Item.find_by_ident params[:ident]
    elsif params[:id]
      @item = Item.find_by_id params[:id]
    end
    if @item == nil or (@item.show? == false and admin? == false)
      add_error t('alerts.invalid_item')
      #logger.debug "pident #{params[:ident]} pid #{params[:id]} item #{@itam}"
      redirect_to :controller => 'home'
    end
  end

  def search
    @query = params[:query] || ''
    @results = Item.find_fulltext(@query, :limit => MAX_RESULTS+1, :offset => 0)
    @more_results = false
    if @results.length > MAX_RESULTS
      @results = @results[0..(MAX_RESULTS-1)]
      @more_results = true
    end
  end

  def edit
    layout 'admin'
    @item = Item.find params[:id]
    if request.post? and params[:item]
      params[:item][:ident].downcase!
      params[:item][:ident].gsub! /\s/, '_'
      @item.update_attributes! prune(params[:item])
      redirect_to :action => 'index', :id => @item
    end
  end

  def delete
    item = Item.find params[:id]
    item.destroy
    redirect_to :controller => 'category', :action => 'index'
  end

  def add_image_to_item
    @item = Item.find params[:id]
    existing = @item.static_assets.find_by_id params[:image]
    if existing
      logger.error "Item ##{@item.id} already has image ##{params[:image]}"
    else
      @item.static_assets << StaticAsset.find(params[:image])
      @item.save!
      logger.info "Image ##{params[:image]} added to item ##{@item.id}"
    end
  end

  def remove_image_from_item
    @item = Item.find params[:id]
    existing = @item.static_assets.find_by_id params[:image]
    if existing
      @item.static_assets.delete existing
      @item.save!
      logger.info "Image ##{params[:image]} removed from item ##{@item.id}"
    else
      logger.error "Item ##{@item.id} does not have image ##{params[:image]}"
    end
  end

  def reorder_item_images
    @item = Item.find params[:id]
    params[:order].split(',').each_with_index do |o, i|
      item_asset = @item.item_assets.find_by_static_asset_id(o.to_i)
      item_asset.position = i
      item_asset.save!
    end
    @item.save!
    logger.info "Image for item ##{@item.id} reordered as #{params[:order]}"
  end
end
