object false
extends 'api/v1/success_header'

child :data do
    child @doctor, root: 'doctor' do
        attributes :full_name, :education, :department_name, :description, :avatar_medium_url
    end
end



