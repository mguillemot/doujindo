class HomeController < ApplicationController
  def index
    from = (rand() < 0.5) ? 'erhune' : 'a-m'
    @osusume = Osusume.find_by_from from
  end

  def faq
  end

  def contact
  end
end
