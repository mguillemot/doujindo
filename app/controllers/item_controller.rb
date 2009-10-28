class ItemController < ApplicationController
  def index
    @item = Item.find params[:id]
    @title = @item.title
    @nav = @item.nav
  end
end
