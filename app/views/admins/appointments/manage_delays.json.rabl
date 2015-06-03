child @doctors, :object_root => false do
  attributes  :id,
              :full_name
  child :appointments, :object_root => false do
        attributes :id,
                   :date_time_ampm,
                   :delayed_date_time_ampm,
                   :patient_full_name
  end


end

