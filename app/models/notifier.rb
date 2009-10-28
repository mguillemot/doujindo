class Notifier < ActionMailer::Base
  def registration_confirmation_request(user)
    common_infos user
    subject '[Touhou Shop] Please confirm your registration'
    body :user => user
  end

  def registration_final_confirmation(user)
    common_infos user
    subject '[Touhou Shop] Registration successful!'
    body :user => user
  end

  protected

  def common_infos(user)
    from 'Touhou Shop <noreply@touhou-shop.com>'
    recipients "#{user.full_name} <#{user.email}>"
  end
end
