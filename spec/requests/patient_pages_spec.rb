require 'spec_helper'

describe 'Patient Pages' do
  subject { page }
  let(:clinic) { FactoryGirl.build(:clinic) }
  let(:patient) { FactoryGirl.create(:patient, clinics: [clinic]) }
  let(:doctor) { FactoryGirl.create(:doctor) }
  before do
    #comment out stub to call real api
    clinic.stub(:call_google_api_for_location).and_return(
        {
            "results" => [
                {
                    "address_components" => [
                        {
                            "long_name" => "55",
                            "short_name" => "55",
                            "types" => [ "street_number" ]
                        },
                        {
                            "long_name" => "Fruit Street",
                            "short_name" => "Fruit St",
                            "types" => [ "route" ]
                        },
                        {
                            "long_name" => "West End",
                            "short_name" => "West End",
                            "types" => [ "neighborhood", "political" ]
                        },
                        {
                            "long_name" => "Boston",
                            "short_name" => "Boston",
                            "types" => [ "locality", "political" ]
                        },
                        {
                            "long_name" => "Suffolk County",
                            "short_name" => "Suffolk County",
                            "types" => [ "administrative_area_level_2", "political" ]
                        },
                        {
                            "long_name" => "Massachusetts",
                            "short_name" => "MA",
                            "types" => [ "administrative_area_level_1", "political" ]
                        },
                        {
                            "long_name" => "United States",
                            "short_name" => "US",
                            "types" => [ "country", "political" ]
                        },
                        {
                            "long_name" => "02114",
                            "short_name" => "02114",
                            "types" => [ "postal_code" ]
                        }
                    ],
                    "formatted_address" => "55 Fruit Street, Boston, MA 02114, USA",
                    "geometry" => {
                        "location" => {
                            "lat" => 42.3632091,
                            "lng" => -71.0686487
                        },
                        "location_type" => "ROOFTOP",
                        "viewport" => {
                            "northeast" => {
                                "lat" => 42.3645580802915,
                                "lng" => -71.0672997197085
                            },
                            "southwest" => {
                                "lat" => 42.3618601197085,
                                "lng" => -71.06999768029151
                            }
                        }
                    },
                    "types" => [ "street_address" ]
                }
            ],
            "status" => "OK"
        }.to_json
    )
    clinic.save!
    switch_to_subdomain('www')
  end

  describe 'need to be logged in to access patient pages' do
    before do
      visit patient_path(patient)
    end
    it { should have_button 'SIGN IN' }
  end

  describe 'signing in' do
    before { visit signin_path }

    it { should have_button('SIGN IN') }
    it { should have_title('Sign In') }

    describe 'with invalid information' do
      before { click_button 'SIGN IN' }
      it { should have_title 'Sign In' }
      it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination'}
    end

    describe 'with valid information' do
      before do
        doctor.save
        fill_in 'email',    with: patient.email
        fill_in 'password', with: 'Qwerty1'
        click_button 'SIGN IN'
      end
      it { should_not have_title 'Sign in' }
      it { should have_link 'Sign Out' }
      it { should have_title 'Home |'}
      it { should_not have_link('Sign in', href: signin_path) }

      # describe 'sidebar' do
      #   it { should have_content 'Browse Doctors' }
      #   it { should have_content 'Profile' }
      #   it { should have_content 'Appointments' }
      #   it { should have_content 'Sign Out' }
      # end

      describe 'patient home page with no upcomming appointments' do
        it { should have_title 'Home |'}
        it { should have_content "Welcome, #{patient.full_name}" }
        it { should have_content 'No upcoming appointments' }
      end

      describe '3 hours left on Appointment' do
        let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                        appointment_time: DateTime.now + 3.hours) }
        before do
          upcoming_appointment.save
          click_link 'HOME'
        end
        it { should have_content 'No upcoming appointments' }
      end

      describe 'patient home page with upcoming appointment' do
        describe '50 minutes left on Appointment' do
          let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                           appointment_time: DateTime.now + 50.minutes) }
          before do
            upcoming_appointment.save
            click_link 'HOME'
          end
          it { should have_selector 'div.appointment-progressbar'}
          it { should have_selector 'div.progress-bar.progress-bar-success' }
          it 'has correct percentage filled' do
            page.find('div.progress-bar.progress-bar-success')['style'].should == 'width: 65%'
          end
        end



        describe '1 hours left on Appointment' do
          let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                          appointment_time: DateTime.now + 1.hour) }
          before do
            upcoming_appointment.save
            click_link 'HOME'
          end
          it { should have_selector 'div.appointment-progressbar'}
          it { should have_selector 'div.progress-bar.progress-bar-success' }
          it 'has correct percentage filled' do
            page.find('div.progress-bar.progress-bar-success')['style'].should == 'width: 50%'
          end
        end

        describe '15 minutes left on Appointment' do
          let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                          appointment_time: DateTime.now + 15.minutes) }
          before do
            upcoming_appointment.save
            click_link 'HOME'
          end
          it { should have_selector 'div.appointment-progressbar'}
          it { should have_selector 'div.progress-bar.progress-bar-warning' }
          it 'has correct percentage filled' do
            page.find('div.progress-bar.progress-bar-warning')['style'].should == 'width: 80%'
          end
        end

        describe '3 minutes left on Appointment' do
          let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                          appointment_time: DateTime.now + 3.minutes) }
          before do
            upcoming_appointment.save
            click_link 'HOME'
          end
          it { should have_selector 'div.appointment-progressbar'}
          it { should have_selector 'div.progress-bar.progress-bar-danger' }
          it 'has correct percentage filled' do
            page.find('div.progress-bar.progress-bar-danger')['style'].should == 'width: 90%'
          end
        end
      end

      describe 'profile page' do
        before do
          click_link 'MY PROFILE'
        end
        it { should have_content patient.first_name }
        it { should have_content patient.last_name }
        it { should have_content patient.email }
        it { should have_content patient.home_phone }
        it { should have_link 'edit profile' }
        it { should have_link 'change password' }

        describe 'edit profile page' do
          before do
            doctor.save
            click_link 'edit profile'
          end

          describe 'with invalid password' do
            before do
              fill_in 'patient_home_phone', with: '000-000-0000'
              click_button 'Update'
            end
            it { should have_selector 'div.alert.alert-danger', text: 'Invalid password entered'}
          end

          describe 'with valid password' do
            describe 'with invalid information' do
              before do
                fill_in 'patient_first_name', with: ''
                fill_in 'verify_verify_password', with: 'Qwerty1'
                click_button 'Update'
              end
              it { should have_selector 'div.alert.alert-danger', text: 'Invalid parameters entered' }
              it { should have_selector 'div.alert.alert-danger', text: 'The form contains 1 error.' }
            end
            describe 'with valid information' do
              before do
                fill_in 'patient_home_phone', with: '000-000-0000'
                fill_in 'verify_verify_password', with: 'Qwerty1'
                click_button 'Update'
              end
              it { should have_content '000-000-0000'}
            end
          end
        end

        describe 'Change password page' do
          before { click_link 'change password' }
          it { should have_content 'Change Password' }
          it { should have_content 'Old password' }
          it { should have_content 'New password' }
          it { should have_content 'Confirm new password' }
          it { should have_button 'Change' }

          describe 'changing the password' do
            describe 'without adding old password' do
              before do
                fill_in 'new_password', with: 'Boobado1'
                fill_in 'new_password_confirm', with: 'Boobado1'
                click_button 'Change'
              end
              it { should have_content 'Change Password' }
              it { should have_content 'Old password' }
              it { should have_selector 'div.alert.alert-danger', text: 'Old password invalid' }
            end
            describe 'with invalid new password format' do
              before do
                fill_in 'old_password', with: patient.password
                click_button 'Change'
              end
              it { should have_selector 'div.alert.alert-danger',
                                        text: 'The form contains 1 error.' }
            end
            describe 'with valid parameters' do
              before do
                fill_in 'old_password', with: patient.password
                fill_in 'new_password', with: 'Boobado1'
                fill_in 'new_password_confirm', with: 'Boobado1'
                click_button 'Change'
              end
              it { should have_selector 'div.alert.alert-success', text: 'Password updated' }
            end
          end
        end
      end

      describe 'cannot view pages of another patient' do
        let(:patient2) { FactoryGirl.create(:patient,
                                            email: 'test2@test.com',
                                            clinics: [clinic],
                                            pid: 124214124,
                                            social_security_number: '123-99-8151')}
        before do
          patient2.save!
          visit patient_path(patient2)
        end
        it { should have_content patient.email }
      end

      # describe 'browse doctor pages' do
      #   let(:doctor) { FactoryGirl.create(:doctor) }
      #   let(:department) { FactoryGirl.create(:department) }
      #   before do
      #     department.save
      #     doctor.save
      #     click_link 'Browse Doctors'
      #   end
      #   it { should have_content doctor.full_name }
      #   it { should have_content doctor.department_name }
      #
      #   describe 'viewing doctor profile' do
      #     before { click_link doctor.full_name }
      #     it { should have_content 'Public Profile' }
      #     it { should have_content doctor.full_name }
      #     it { should have_content doctor.email }
      #     it { should have_content doctor.phone_number }
      #   end
      # end

      describe 'editing requests pages' do
        let(:appointment) { FactoryGirl.create(:appointment_request) }
        let(:doctor) { FactoryGirl.create(:doctor) }
        before do
          doctor.save
          appointment.save
          click_link 'MY APPOINTMENTS'
          click_link 'Open Requests'
        end
        it { should have_content appointment.date_time_ampm }
        it { should have_content appointment.doctor.full_name }
        it { should have_link '1' }

        describe 'editing a request' do
          before do
            click_link 'Edit'
            select '4:45 PM', from: 'date_time'
          end
          it { expect do
            click_button 'Update'
            appointment.reload
          end.to change(appointment, :appointment_time) }
        end

        describe 'deleting requests' do
          before do
            click_link 'Edit'
            click_link 'Delete Request'
          end
          it { should_not have_content appointment.date_time_ampm }
        end

        describe 'should delete appointment request' do
          before do
            click_link 'Edit'
          end
          it 'should change appointment count' do
            expect do
              click_link('Delete Request')
            end.to change(Appointment, :count).by(-1)
          end
        end
      end

      describe 'signing out' do
        before { click_link 'Sign Out' }
        it { should have_link('SIGN IN') }
      end
    end


    describe 'Forgot Password Page' do
      before do
        click_link 'forgot password?'
      end
      it { should have_content 'Email' }
      it { should have_title 'Forgot Password' }

      describe 'resetting password' do
        before do
          fill_in 'Email', with: patient.email
          click_button 'Submit'
        end
        it { should have_content 'An email has been sent containing your new password'}
        it 'Email should be sent to user' do
          last_email.to.should include(patient.email)
        end
      end
    end
  end

  describe 'Profile page' do
    describe 'need to be logged in as patient to view profile' do
      before { visit patient_path(patient) }
      it { should_not have_content patient.email }
    end
  end



  #separated due to swtich to webkit from rack
  describe 'Request an appointment', :js => true do
    let(:appointment) { FactoryGirl.create(:appointment_request) }
    let(:doctor)  { FactoryGirl.create(:doctor) }
    before do
      doctor.save!
      patient.save!
      appointment.save!
      visit root_path
      click_link 'SIGN IN'
      fill_in 'email', with: patient.email
      fill_in 'password', with: 'Qwerty1'
      click_button 'SIGN IN'
      click_link 'APPOINTMENTS'
      click_link 'New Request'
    end
    describe 'with invalid (past) date' do
      before do
        fill_in 'appointment_date', with: 3.days.ago.strftime('%F')
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-danger', text: 'Time must be set in the future' }
    end

    describe 'with valid date' do
      before do
        fill_in 'appointment_date', with: 3.days.from_now.strftime('%F')
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-success', text: 'Appointment Requested'}
    end

    describe 'Can only choose doctors in same clinic' do
      let(:doctor2) { FactoryGirl.create(:doctor,
                                         email: 'newDoc@doc.com',
                                         clinic_id: 2) }
      before do
        doctor2.save
        click_link 'Appointments'
        click_link 'New Request'
      end
      it 'should not list doctor2 in available doctors' do
        find(:css, 'select#appointment_doctor_id').value.should_not eq 2
      end
    end
  end
end
