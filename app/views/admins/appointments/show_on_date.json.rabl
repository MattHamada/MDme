child @appointments, :object_root => false do
  attributes  :id,
              :time_ampm,
              :doctor_full_name,
              :patient_full_name,
              :date
end

node(:doctor) {@doctor}
node(:date) {@date.strftime("%F")}