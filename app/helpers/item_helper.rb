module ItemHelper
  def stock_display(item)
    if item.reservation_end_date
      res = t('item.availability.preorder', :end => item.reservation_end_date.to_s)
    else
      res = ''
      res += t('item.availability.new', :count => item.stock_left_new) + '<br/>' if item.stock_left_new > 0
      res += t('item.availability.purchase', :count => item.purchase_left) + '<br/>' if item.purchase_left > 0
      res += t('item.availability.perfect_condition', :count => item.stock_left_perfect_condition) + '<br/>' if item.stock_left_perfect_condition > 0
      res += t('item.availability.good_condition', :count => item.stock_left_good_condition) + '<br/>' if item.stock_left_good_condition > 0
      res += t('item.availability.medium_condition', :count => item.stock_left_medium_condition) + '<br/>' if item.stock_left_medium_condition > 0
      res += t('item.availability.poor_condition', :count => item.stock_left_poor_condition) + '<br/>' if item.stock_left_poor_condition > 0
      res = t('item.availability.na') if res == ''
    end
    res
  end

  def track_urls(tracks)
    files = tracks.collect { |t| "'#{static_url(t.full_filename)}'" }
    files.join(',')
  end
end
