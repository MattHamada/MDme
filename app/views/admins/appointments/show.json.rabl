child @appointment, :object_root => false do
  attributes :id,
             :date_time_ampm,
             :doctor_full_name,
             :patient_full_name,
             :description
end

child @doctor, :object_root => false do
  attributes :id
end

child @patient, :object_root => false do
  attributes :id
end




