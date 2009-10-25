require "session/session_cart"

class CartController < ApplicationController
  def summary
    @title = "Shopping cart summary"
  end

  def add
    if !session[:cart]
      session[:cart] = SessionCart.new
      flash[:debug] = "Shopping cart created"
    end
    session[:cart].add(params[:id], 1)
    flash[:notice] = "Item #{params[:id]} added to cart"
    redirect_to :controller => 'item', :action => 'show', :id => params[:id]
  end

  def remove
  end

  def clear
  end

  def checkout
  end
end
