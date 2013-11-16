FactoryGirl.define do
  factory :patient do
    first_name            'fname'
    last_name             'lname'
    email                 'patient@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end

  factory :doctor do
    first_name            'healthy'
    last_name             'doctor'
    email                 'doctor@example.com'
    password              'foobar'
    password_confirmation 'foobar'
    department_id            '1'
  end

  factory :admin do
    email                 'admin@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end

  factory :appointment do
    doctor_id     '1'
    patient_id    '1'
    appointment_time          DateTime.new(2013, 11, 23, 5, 45, 00)
    description   'test'
  end

  factory :department do
    name 'Oncology'
  end
end