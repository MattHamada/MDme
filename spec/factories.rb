FactoryGirl.define do
  factory :patient do
    first_name            'fname'
    last_name             'lname'
    email                 'patient@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end

  factory :admin do
    email                 'admin@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end
end