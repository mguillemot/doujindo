class ItemController < ApplicationController
  def show
    @item = Item.find params[:id]
    @title = @item.title
    @nav = @item.nav
  end
end
