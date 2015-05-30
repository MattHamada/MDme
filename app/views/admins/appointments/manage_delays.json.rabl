child @doctors, :object_root => false do
  attributes  :id,
              :full_name
  child :appointments do
        attributes


end

        #TODO want {doctors: [{id: 1, appointments: [{id: 12,...}]}]}