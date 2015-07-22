def sign_in_patient
  fill_in 'signin_email',    with: patient.email
  fill_in 'signin_password', with: patient.password
  click_button 'SIGN IN'
end