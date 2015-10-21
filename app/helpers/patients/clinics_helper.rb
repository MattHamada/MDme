module Patients::ClinicsHelper
  def date_slot_header_formatter(date)
    day_number = date.strftime('%e')
    suffix = ''
    case day_number[-1]
      when '1'
        suffix = 'st'
      when '2'
        suffix = 'nd'
      when '3'
        suffix = 'rd'
      else
        suffix = 'th'
    end
    "#{date.strftime('%A, %B %e')}<sup>#{suffix}</sup>".html_safe
  end

  def clinic_address(clinic)
    concat(clinic.address1)
    content_tag(:div, :style=>'margin-left: 10.2em') do
      concat(content_tag(:div, clinic.address2))
      concat(content_tag(:div, clinic.address3))
      concat(content_tag(:div, "#{clinic.city}, #{clinic.state}"))
      concat(content_tag(:div, clinic.zipcode))
    end
  end

  def clinic_hours(clinic)
    days = %w(sunday monday tuesday wednesday thursday friday saturday)
    content_tag(:div, :id=>'clinic-times') do
      days.each do |day|
        concat(content_tag(:span, content_tag(:b, "#{day.titleize}:")))
        if clinic.send("is_open_#{day}")
          if Time.zone.now.strftime("%A") == day.titleize
            concat(content_tag(:strong, "#{clinic.send("#{day}_open_time")} - #{clinic.send("#{day}_close_time")}"))
          else
            concat("#{clinic.send("#{day}_open_time")} - #{clinic.send("#{day}_close_time")}")
          end
        else
          concat("CLOSED")
        end
        concat(tag(:br))
      end
    end
  end
end
