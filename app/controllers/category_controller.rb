class CategoryController < ApplicationController
  def index
    @category = Category.find params[:id]
    @title = @category.title
    @nav = @category.nav
  end
end
