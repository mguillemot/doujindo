class HomeController < ApplicationController
  def index
    from = (rand() < 0.5) ? 'erhune' : 'a-m'
    @osusume = Osusume.find_by_from from
    @news = News.find :first, :order => 'created_at DESC'
    @random_items = Item.find :all, :conditions => '`show` = 1 AND stock > 0', :order => 'RAND()', :limit => 4
  end

  def faq
    @categories = FaqEntry.find_all_by_category true, :order => 'display_order asc'
  end

  def contact
    @email = @user.email if @user
    if request.post?
      Contacter.deliver_incoming_contact @user, params[:email], params[:content]
      add_notice_now t('alerts.contact_form_message_sent')
      @email = params[:email]
    end
  end
end
