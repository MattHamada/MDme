child @appointment, :object_root => false do
  attributes :id,
             :date_time_ampm,
             :doctor_full_name,
             :patient_full_name,
             :description,
             :appointment_time

  attribute  :time_selector => :time
end

child @doctor, :object_root => false do
  attributes :id
end

child @patient, :object_root => false do
  attributes :id
end




