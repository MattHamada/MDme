child @appointments, :object_root => false do
  attributes :id,
             :time_ampm,
             :delayed_time_ampm,
             :doctor_full_name,
             :patient_full_name
end