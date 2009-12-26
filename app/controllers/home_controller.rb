class HomeController < ApplicationController
  def index
    from = (rand() < 0.5) ? 'erhune' : 'a-m'
    @osusume = Osusume.find_by_from from
    @news = News.find :first, :order => 'created_at DESC'
    @random_items = Item.find :all, :conditions => '`show` = 1 AND stock > 0', :order => 'RAND()', :limit => 4
  end

  def faq
  end

  def contact
  end
end
