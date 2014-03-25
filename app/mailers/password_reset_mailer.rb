class PasswordResetMailer < ActionMailer::Base
  default from: "no-reply@mdme.us"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.forgot_password_mailer.reset_email.subject
  #
  def reset_email(user, temp_pass)
    @user = user
    @temp_pass = temp_pass
    mail to: @user.email, subject: 'Password Reset'
  end
end
