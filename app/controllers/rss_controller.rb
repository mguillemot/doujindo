class RssController < ApplicationController
  def items
    @items = Item.find :all, :conditions => ['`show` = ?', true], :order => 'created_at desc' 
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
