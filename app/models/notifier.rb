class Notifier < ActionMailer::Base
  def registration_confirmation_request(user)
    common_infos user
    subject I18n.t('mail.registration_confirmation_request.subject')
    body :user => user
  end

  def registration_final_confirmation(user)
    common_infos user
    subject I18n.t('mail.registration_final_confirmation.subject')
    body :user => user
  end

  def password_forgotten(user)
    common_infos user
    subject I18n.t('mail.password_forgotten.subject')
    body :user => user
  end

  def order_confirmation(order)
    common_infos order.client
    subject I18n.t('mail.order_confirmation.subject', :id => order.id)
    body :user => order.client, :order => order
  end

  protected

  def common_infos(user)
    from 'Touhou Shop <noreply@touhou-shop.com>'
    recipients user.email
  end

  private

  # we override the template_path to render localized templates (since rails does not support that :-( )
  # This thing is not testable since you cannot access the instance of a mailer...
  def initialize_defaults(method_name)
    super
    @template = "#{I18n.locale}_#{method_name}"
  end
end
