module ItemHelper
  def stock_display(item)
    if item.stock > 0
      case item.stock_type
        when 'new'
          res = t('item.availability.new', :count => item.stock)
        when 'used'
          res = t('item.availability.new', :count => item.stock)
        when 'preorder'
          res = t('item.availability.new', :count => item.stock)
      end
    else
      res = t('item.availability.na')
    end

#    if item.reservation_end_date
#      res = t('item.availability.preorder', :end => item.reservation_end_date.to_s)
#    else


#      res = t('item.availability.purchase', :count => item.purchase_left) if item.purchase_left > 0
#      res = t('item.availability.perfect_condition', :count => item.stock_left_perfect_condition) if item.stock_left_perfect_condition > 0
#      res = t('item.availability.good_condition', :count => item.stock_left_good_condition) if item.stock_left_good_condition > 0
#      res = t('item.availability.medium_condition', :count => item.stock_left_medium_condition) if item.stock_left_medium_condition > 0
#      res = t('item.availability.poor_condition', :count => item.stock_left_poor_condition) if item.stock_left_poor_condition > 0
#    end
    res
  end

  def track_urls(tracks)
    files = tracks.collect { |t| "'#{static_url(t.full_filename)}'" }
    files.join(',')
  end
end
