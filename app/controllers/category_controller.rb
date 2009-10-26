class CategoryController < ApplicationController
  def show
    @category = Category.find params[:id]
    @title = @category.title
    @nav = @category.nav
  end
end
