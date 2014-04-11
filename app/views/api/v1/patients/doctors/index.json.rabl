object false
extends 'api/v1/success_header'

child :data do
  child @doctors, :object_root => false do
    attributes :id, :full_name, :avatar_thumb_url
  end
end