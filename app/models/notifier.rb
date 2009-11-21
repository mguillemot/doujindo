class Notifier < ActionMailer::Base
  def registration_confirmation_request(user)
    common_infos user
    subject I18n.t('mail.registration_confirmation_request.title')
    body :user => user
  end

  def registration_final_confirmation(user)
    common_infos user
    subject I18n.t('mail.registration_final_confirmation.title')
    body :user => user
  end

  def order_confirmation(order)
    common_infos order.client
    subject "Order ##{order.id} confirmed"
    body :user => order.client, :order => order
  end

  protected

  def common_infos(user)
    from 'Touhou Shop <noreply@touhou-shop.com>'
    recipients "#{user.full_name} <#{user.email}>"
  end

  private

  # we override the template_path to render localized templates (since rails does not support that :-( )
  # This thing is not testable since you cannot access the instance of a mailer...
  def initialize_defaults(method_name)
    super
    @template = "#{I18n.locale}_#{method_name}"
  end
end
