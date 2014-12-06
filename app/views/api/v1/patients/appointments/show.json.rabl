object false
extends 'api/v1/success_header'

child :data do
  child @appointment, root: 'appointment' do
    attributes :clinic_name,
               :doctor_avatar_thumb_url,
               :date,
               :delayed_time_ampm,
               :doctor_full_name,
               :request,
               :description
  end
end




