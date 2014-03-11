class PatientMailer < ActionMailer::Base
  default from: "no-reply@mdme.us"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.patient_mailer.appointment_delayed_email.subject
  #
  def appointment_delayed_email(patient, new_time)
    @patient = patient
    @new_time = new_time.strftime("%m-%e-%y %I:%M%p")

    mail to: @patient.email, subject: 'Appointment time changed'
  end
end
