object false
extends 'api/v1/success_header'


child :data do
    child @departments, :object_root => false do
     attributes :id, :name
end
end
