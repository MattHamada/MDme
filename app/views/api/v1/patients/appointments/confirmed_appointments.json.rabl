object false
extends 'api/v1/success_header'

child :data do
    child @appointments, :object_root => false do
        attributes :id, :delayed_date_time_ampm, :doctor_full_name, :doctor_id, :description
    end
end