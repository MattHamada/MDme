module AppointmentTimeFormatting
  def date
    appointment_time.strftime('%F')
  end

  def date_time_ampm
    appointment_time.strftime('%F %I:%M%p')
  end

  def delayed_date_time_ampm
    appointment_delayed_time.strftime('%F %I:%M%p')
  end

  def delayed_time_ampm
    appointment_delayed_time.strftime('%I:%M%p')
  end

  def time_am_pm
    appointment_time.strftime('%I:%M %p')
  end
  alias_method :time_ampm, :time_am_pm

  def time_selector
    last = appointment_time.strftime(":%M %p")
    "#{appointment_time_hour}#{last}"
  end

  def appointment_time_hour
    appointment_time.strftime("%I").to_i
  end

  def appointment_time_hour_24
    appointment_time.strftime("%H").to_i
  end

  def appointment_time_minute
    appointment_time.min
  end
end