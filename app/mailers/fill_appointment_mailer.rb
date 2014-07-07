class FillAppointmentMailer < ActionMailer::Base
  default from: "no-reply@mdme.us"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.signup_confirmation.subject
  #
  def ask_fill_appointment(user, orig_appointment, new_time)
    @user = user
    @orig_appointment = orig_appointment
    @new_time = new_time

    mail to: user.email, subject: 'Appointment time change request'
  end
end
