child @appointment, :object_root => false do
  attributes :id,
             :clinic_name,
             :date_time_ampm,
             :doctor_full_name,
             :description
end

child @doctor, :object_root => false do
  attributes :id
end




