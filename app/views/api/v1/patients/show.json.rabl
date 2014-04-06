object false
extends 'api/v1/success_header'

child :data do
  child @patient, root: 'patient' do
    attributes :first_name, :last_name, :email, :phone_number, :avatar_thumb_url

  end
end




