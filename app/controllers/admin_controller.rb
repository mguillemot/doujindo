class AdminController < ApplicationController
  before_filter :admin_required
  layout 'admin'

  def orders
    @orders = Order.find_all_by_payment_status 'paid'
  end

  def order
    @order = Order.find params[:id]
  end
end
