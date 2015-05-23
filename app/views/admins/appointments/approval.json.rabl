child @appointments, :object_root => false do
  attributes :id,
             :date_time_ampm,
             :doctor_full_name,
             :patient_full_name,
             :date
end