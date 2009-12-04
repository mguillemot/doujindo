class CategoryController < ApplicationController
  before_filter :admin_required, :only => :new_item

  def index
    id = params[:id] || session[:category_id]
    @category = Category.find id
    @display_items = admin? ? @category.all_items : @category.visible_items
    session[:category_id] = id
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
