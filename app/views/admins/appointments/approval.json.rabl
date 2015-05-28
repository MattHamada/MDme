child @appointments, :object_root => false do
  attributes :id,
             :date_time_ampm,
             :date,
             :doctor_full_name,
             :doctor_id,
             :patient_full_name,
             :underscore_date
end