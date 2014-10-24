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

  def appointment_update_time_email(patient, new_time)
    @patient = patient
    @new_time = new_time.strftime("%m-%e-%y %I:%M%p")
    mail to: @patient.email, subject: 'Appointment moved up'
  end

  def appointment_confirmation_email(appointment)
    @patient = appointment.patient
    @appointment_new_time = appointment.date_time_ampm

    mail to: @patient.email, subject: 'Appointment approved'
  end


  def appointment_deny_email(appointment)
    @patient = appointment.patient
    @appointment_new_time = appointment.date_time_ampm

    mail to: @patient.email, subject: 'Appointment denied'

  end
end
