class SignupMailer < ActionMailer::Base
  default from: "no-reply@mdme.us"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user, tempPass)
    @tempPass = tempPass
    @user = user

    mail to: user.email, subject: 'Sign Up Confirmation'
  end
end
