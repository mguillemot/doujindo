class CategoryController < ApplicationController
  before_filter :admin_required, :only => :new_item

  ITEMS_PER_PAGE = 10

  def index
    if params[:ident]
      @category = Category.find_by_ident params[:ident]
    else
      @category = Category.find_by_id(params[:id] || session[:category_id])
    end
    if @category == nil
      add_error t('alerts.invalid_category')
      redirect_to :controller => 'home'
    else
      session[:category_id] = @category.id
      @sort = params[:sort]
      @page = Integer(params[:page])
      items = admin? ? @category.all_items : @category.visible_items
      @npages = (items.length.to_f / ITEMS_PER_PAGE).ceil
      if @page < 1
        @page = 1
      elsif @page > @npages
        @page = @npages
      end
      items.sort! { |a, b| b.created_at <=> a.created_at }
      case @sort
        when 'by-name'
          items.sort! { |a, b| a.title <=> b.title }
        when 'by-price'
          items.sort! { |a, b| a.price <=> b.price }
        when 'by-type'
          items.sort! { |a, b| a.item_type <=> b.item_type }
        when 'by-availability'
          items.sort! { |a, b| b.availability_type <=> a.availability_type }
      end
      @display_items = items[((@page-1)*ITEMS_PER_PAGE)..(@page*ITEMS_PER_PAGE-1)]
      logger.debug "Display category #{@category.id} sorting #{@sort} starting at page #{@page}"
    end
  end

  def new_item
    @category = Category.find params[:id]
    item = @category.items.create!(
            :title_en => '(new item)',
            :title_fr => '(new item)',
            :ident => Utils.random_string(16),
            :author_en => '(edit)',
            :author_fr => '(edit)',
            :item_type_en => '(edit)',
            :item_type_fr => '(edit)',
            :description_en => '(edit)',
            :description_fr => '(edit)',
            :weight => 1,
            :dimension_width => 1,
            :dimension_height => 1,
            :dimension_thickness => 1,
            :price => 0,
            :show => false
    )
    add_debug "New item ##{item.id} created"
    redirect_to :controller => 'item', :action => 'edit', :id => item
  end
end
