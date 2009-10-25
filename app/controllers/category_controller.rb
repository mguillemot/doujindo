class CategoryController < ApplicationController
  def show
    @category = Category.find params[:id]
    @title = @category.title
    parent = @category.parent
    @nav = @category.nav
  end
end
