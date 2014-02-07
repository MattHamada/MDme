FactoryGirl.define do
  factory :patient do
    first_name            'fname'
    last_name             'lname'
    email                 'patient@example.com'
    password              'foobar'
    password_confirmation 'foobar'
    doctor_id             '1'
  end

  factory :doctor do
    first_name            'healthy'
    last_name             'doctor'
    email                 'doctor@example.com'
    password              'foobar'
    password_confirmation 'foobar'
    department_id            '1'
    degree                'DO'
    alma_mater            'Midwestern University'
    description            Faker::Lorem.paragraph(4)
    phone_number          '123-456-7890'
  end

  factory :admin do
    email                 'admin@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end

  factory :appointment do
    doctor_id     '1'
    patient_id    '1'
    appointment_time          DateTime.now + 3.days
    description   'test'
    request false
  end

  factory :appointment_request, class: Appointment do
    doctor_id     '1'
    patient_id    '1'
    appointment_time          DateTime.now + 3.days
    description   'test'
    request true
  end

  factory :department do
    name 'Oncology'
  end
end