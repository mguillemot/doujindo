module CartHelper
  def cart_index_nav
    [ [ t('cart.edit.nav'), { :controller => 'cart', :action => 'index' } ] ]
  end
end
