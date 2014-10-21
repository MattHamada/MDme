object false
extends 'api/v1/success_header'

child :data do
  child @clinic, :object_root => false do
    attributes :id,
               :name,
               :address1,
               :address2,
               :address3,
               :city,
               :state,
               :country,
               :zipcode,
               :phone_number,
               :fax_number,
               :ne_latitude,
               :ne_longitude,
               :sw_latitude,
               :sw_longitude
  end
end