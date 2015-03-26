child @patient, :object_root => false do
  attributes :id,
             :first_name,
             :last_name,
             :full_name,
             :email,
             :home_phone,
             :work_phone,
             :mobile_phone,
             :avatar_medium_url,
             :avatar_thumb_url,
             :social_last_four
end