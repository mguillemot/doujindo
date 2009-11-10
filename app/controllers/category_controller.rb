class CategoryController < ApplicationController
  before_filter :admin_required, :only => :new_item

  def index
    @category = Category.find params[:id]
    @display_items = admin? ? @category.all_items : @category.visible_items
  end

  def new_item
    @category = Category.find params[:id]
    item = @category.items.create(
            :title_en => '(new item)',
            :title_fr => '(new item)',
            :ident => Utils.random_string(16),
            :author_en => '(edit)',
            :author_fr => '(edit)',
            :item_type_en => '(edit)',
            :item_type_fr => '(edit)',
            :description_en => '(edit)',
            :description_fr => '(edit)',
            :stock_left => 0,
            :purchase_left => 0,
            :reservation_left => 0,
            :price => 0,
            :show => false
    )
    logger.debug "itemId=#{item.id}"
    redirect_to :controller => 'item', :action => 'edit', :id => item.id
  end
end
