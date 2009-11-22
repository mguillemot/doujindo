module OrderHelper
  def order_index_nav
    cart_index_nav << [ t('checkout.index.nav'), { :controller => 'order', :action => 'index' } ]
  end

  def order_review_nav
    order_index_nav << [ t('checkout.review.nav'), { :controller => 'order', :action => 'review' } ]
  end

  def order_confirmation_nav
    [ [ t('checkout.confirmation.nav'), { :controller => 'order', :action => 'confirmation' } ] ]
  end
end
