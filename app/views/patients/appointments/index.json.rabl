child @appointments, :object_root => false do
  attributes :id,
             :clinic_name,
             :date,
             :delayed_time_ampm,
             :doctor_full_name
end