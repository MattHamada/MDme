child @appointments, :object_root => false do
  attributes :id,
             :time_am_pm,
             :delayed_time_ampm,
             :doctor_full_name,
             :patient_full_name,
             :doctor_full_name,
             :checked_in
end