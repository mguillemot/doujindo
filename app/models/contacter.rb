class Contacter < ActionMailer::Base
  def incoming_contact(user, email, content)
    from 'Contact Form <noreply@touhou-shop.com>'
    recipients 'contact@touhou-shop.com'
    subject 'Incoming message'
    body :user => user, :email => email, :content => content
  end
end
