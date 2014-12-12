class PatientRegistrationPdf
  include Prawn::View
  LINE_SPACING = 23
  def initialize(patient)
    super()
    @patient = patient
    font 'Times-Roman'
    stroke_axis
    default_leading 10
    header('General Information')
    patient_information
  end

  def header(words)
    pad_bottom(5) do
      fill_color 'DDDDDD'
      fill_and_stroke_rectangle [0, 728], 528, 25
      fill_color '000000'
      text "#{words}", style: :bold, size: 16, align: :center
    end
  end

  def patient_information
    #line1
    text_height = 678
    line_height = 675
    draw_text 'Last Name:', style: :bold, at: [0, text_height]
    draw_text "#{@patient.last_name}", font: 'Courier', at: [70, text_height]
    draw_text 'First Name:', style: :bold, at: [192, text_height]
    draw_text "#{@patient.first_name}", font: 'Courier', at: [265, text_height]
    draw_text 'Middle Initial:', style: :bold, at: [385, text_height]
    draw_text "#{@patient.middle_initial[0]}", font: 'Courier', at: [465, text_height]
    stroke do
      horizontal_line 60, 185, at: line_height
      horizontal_line 255, 380, at: line_height
      horizontal_line 460, 480, at: line_height
    end
    #line2
    text_height -= LINE_SPACING
    line_height -= LINE_SPACING
    draw_text 'Prefix:', style: :bold, at: [0,text_height]
    draw_text "#{@patient.name_prefix}", font: 'Courier', at: [40, text_height]
    draw_text 'Suffix:', style: :bold, at: [95, text_height]
    draw_text "#{@patient.name_suffix}", font: 'Courier', at: [138, text_height]
    draw_text 'Birthday:', style: :bold, at: [192, text_height]
    draw_text "#{@patient.birthday.month} / #{@patient.birthday.day} / #{@patient.birthday.year}", font: 'Courier', at: [250, text_height]
    draw_text 'Sex:',   style: :bold, at: [338, text_height]
    draw_text 'Male',   style: :bold, at: [390, text_height]
    draw_text 'Female', style: :bold, at: [450, text_height]
    stroke do
      horizontal_line 36, 86, at: line_height
      horizontal_line 132, 178, at: line_height
      horizontal_line 245, 330, at: line_height
      rectangle       [370, (text_height  + 10)], 12, 12
      rectangle       [430, (text_height  + 10)], 12, 12
    end
    self.line_width = 3
    stroke do
      if @patient.is_male
        line [372, text_height], [385, (text_height + 15)]
      else
        line [432, text_height], [445, (text_height + 15)]
      end
    end
    self.line_width = 1
    #line3
    text_height -= LINE_SPACING
    line_height -= LINE_SPACING
    draw_text 'SS#:', style: :bold, at: [0, text_height]
    draw_text "#{@patient.social_security_number}", font: :courier, at: [30, text_height]
    draw_text 'Marital Status:', style: :bold, at: [110, text_height]
    draw_text 'Single',   style: :bold, at: [215, text_height]
    draw_text 'Married',  style: :bold, at: [275, text_height]
    draw_text 'Widowed',  style: :bold, at: [345, text_height]
    draw_text 'Divorced', style: :bold, at: [422, text_height]
    draw_text 'Other',    style: :bold, at: [498, text_height]
    stroke do
      horizontal_line 25, 100, at: line_height
      rectangle       [198, (text_height + 10)], 12, 12
      rectangle       [258, (text_height + 10)], 12, 12
      rectangle       [328, (text_height + 10)], 12, 12
      rectangle       [405, (text_height + 10)], 12, 12
      rectangle       [480, (text_height + 10)], 12, 12
    end
    self.line_width = 3
    stroke do
      case @patient.marital_status
        when Patient::MaritalStatus::SINGLE
          line [200, text_height], [213, (text_height + 15)]
        when Patient::MaritalStatus::MARRIED
          line [260, text_height], [273, (text_height + 15)]
        when Patient::MaritalStatus::WIDOWED
          line [330, text_height], [343, (text_height + 15)]
        when Patient::MaritalStatus::DIVORCED
          line [407, text_height], [420, (text_height + 15)]
        when Patient::MaritalStatus::OTHER
          line [482, text_height], [494, (text_height + 15)]
      end
    end
    self.line_width = 1
    #line4
    text_height -= LINE_SPACING
    line_height -= LINE_SPACING
    draw_text 'Address 1:', style: :bold, at: [0, text_height]
    draw_text "#{@patient.address1}", font: 'Courier', at: [65, text_height]
    draw_text 'City:', style: :bold, at: [310, text_height]
    draw_text "#{@patient.city}", font: 'Courier', at: [342, text_height]
    stroke do
      horizontal_line 55,  300, at: line_height
      horizontal_line 335, 500, at: line_height
    end
    #line5
    text_height -= LINE_SPACING
    line_height -= LINE_SPACING
    draw_text 'Address 2:', style: :bold, at: [0, text_height]
    draw_text "#{@patient.address2}", font: 'Courier', at: [65, text_height]
    draw_text 'State:', style: :bold, at: [310, text_height]
    draw_text "#{@patient.state}", font: 'Courier', at: [344, text_height]
    draw_text 'Zip:', style: :bold, at: [375, text_height]
    draw_text "#{@patient.zipcode}", font: 'Courier', at: [405, text_height]

    stroke do
      horizontal_line 55,  300, at: line_height
      horizontal_line 342, 367, at: line_height
      horizontal_line 402, 445, at: line_height

    end
  end
end