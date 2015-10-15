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
end
