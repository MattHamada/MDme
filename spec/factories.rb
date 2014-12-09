FactoryGirl.define do

  factory :patient do
    first_name            'fname'
    last_name             'lname'
    email                 'patient@example.com'
    password              'Qwerty1'
    password_confirmation 'Qwerty1'
    doctor_id             '1'
    pid                   Random.rand(20000)
  end

  factory :doctor do
    first_name            'healthy'
    last_name             'doctor'
    email                 'doctor@example.com'
    password              'Qwerty1'
    password_confirmation 'Qwerty1'
    department_id            '1'
    degree                'DO'
    alma_mater            'Midwestern University'
    description            Faker::Lorem.paragraph(4)
    phone_number          '123-456-7890'
    clinic_id             '1'
  end

  factory :admin do
    email                 'admin@example.com'
    password              'Qwerty1'
    password_confirmation 'Qwerty1'
    clinic_id             '1'
  end

  factory :appointment do
    doctor_id             '1'
    patient_id            '1'
    appointment_time      { (DateTime.now + 3.days).change({hour: 11, minute: 15}) }
    description           'test'
    request               false
    clinic_id             '1'

  end

  factory :appointment_today, class: Appointment do
    doctor_id             '1'
    patient_id            '1'
    appointment_time      { (DateTime.now + 1.hour).change({minute: 30}) } #bracketed to set time on instantiation, required for timecop
    description           'test'
    request false
    clinic_id             '1'
  end

  factory :appointment_request, class: Appointment do
    doctor_id             '1'
    patient_id            '1'
    appointment_time      { (DateTime.now + 3.days).change({hour: 9, minute: 00}) }
    description           'test'
    request true
    clinic_id             '1'
  end

  factory :department do
    name                  'Oncology'
    clinic_id             '1'
  end

  factory :clinic do
    name                  'MGH'
    address1              'Scheduling Office'
    address2              '55 fruit street'
    address3              'Room 121'
    city                  'Boston'
    state                 'Massachusetts'
    zipcode               '02114'
    country               'United States'
    phone_number          '617-726-2000'
    fax_number            '617-726-3000'
  end

  factory :device do
    patient_id          '1'
    token               'aaa'
    platform            'android'
    enabled             'false'
  end
end
