class UserMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com' 

  def welcome_email(user)
    @user = user
    @url  = root_url
    mail(to: @user.email, subject: 'Welcome to ShiftCover!')
  end
end
