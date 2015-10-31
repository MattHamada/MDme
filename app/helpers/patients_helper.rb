module PatientsHelper
  def patient_address(patient)
     content_tag(:div) do
       if patient.address1.present?
         concat(patient.address1)
         concat(tag(:br))
       end
       if patient.address2.present?
         concat(patient.address2)
         concat(tag(:br))
       end
       if patient.city.present?
         if patient.state.present?
         concat("#{patient.city}, #{patient.state}")
         if patient.country.present?
           concat(tag(:br))
           concat(patient.country)
         end
         else
           if patient.country.present?
             concat("#{patient.city}, #{patient.country}")
           else
             concat("#{patient.city}")
           end
         end
         concat(tag(:br))
       end
       if patient.zipcode.present?
         concat(patient.zipcode)
         concat(tag(:br))
       end
     end
  end
end
