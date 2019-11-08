class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'
  include ActionView::Helpers::UrlHelper

  def alert_email()

    # @confirmation_url = base_url + '/myuser/confirmation?confirmation_token=' + myuser.confirmation_token
    # #http://localhost:3000/users/confirmation?confirmation_token=x8gcudMm2xyuJGwA6UvK
    # @email_address = myuser.email
    mail(from: "noreply@test.com", to: "dan.tench@gmail.com", subject: 'This is a test' )
  end


end
