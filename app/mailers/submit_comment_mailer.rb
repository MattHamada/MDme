class SubmitCommentMailer < ActionMailer::Base
  default from: "no-reply@mdme.us"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.signup_confirmation.subject
  #
  def send_email(name, email, phone, comment)
    @name = name
    @email = email
    @phone = phone
    @comment = comment

    mail to: 'contact@mdme.us', subject: 'Main page contact form'
  end
end
