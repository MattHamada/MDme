module AppointmentTimeFormatting
  def date
    appointment_time.strftime("%F")
  end

  def date_time_ampm
    appointment_time.strftime("%F %I:%M%p")
  end

  def delayed_date_time_ampm
    appointment_delayed_time.strftime("%F %I:%M%p")
  end

  def time_am_pm
    appointment_time.strftime("%I:%M%p")
  end

  def appointment_time_hour
    appointment_time.hour
  end

  def appointment_time_minute
    appointment_time.min
  end
end