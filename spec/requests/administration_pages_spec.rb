require 'spec_helper'

describe 'AdministrationPages' do
  let(:clinic)      { FactoryGirl.build(:clinic) }
  let(:admin)       { FactoryGirl.create(:admin) }
  let(:appointment) { FactoryGirl.create(:appointment) }
  let(:doctors)      { FactoryGirl.create(:doctors) }
  let(:department)  { FactoryGirl.create(:department) }
  let(:patient)     { FactoryGirl.create(:patient, clinics: [clinic]) }
  let(:device)      { FactoryGirl.create(:device) }
  subject { page }
  before do
    #comment out stub to call real api
    allow(clinic).to receive(:call_google_api_for_location).and_return(
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
    switch_to_subdomain('admin')
  end

  describe 'root signin page' do
    before { visit root_path }

    it { is_expected.to have_title('Sign In')}
    it { is_expected.to have_content('Admin Sign In')}

    describe 'Forgot Password Page' do
      before do
        click_link 'Forgot Password'
      end
      it { is_expected.to have_content 'Email' }
      it { is_expected.to have_title 'Forgot Password' }

      describe 'resetting password' do
        before do
          fill_in 'Email', with: admin.email
          click_button 'Submit'
        end
        it { is_expected.to have_content 'An email has been sent containing your new password'}
        it 'Email should be sent to user' do
          expect(last_email.to).to include(admin.email)
        end
      end
    end

    describe 'signing in' do
      describe 'need to be signed in to get to admin pages' do
        before { visit admins_path }
        it { is_expected.to have_content 'Sign In' }
      end
      describe 'wih invalid information' do
        before do
          fill_in 'email', with: 'wrong@example.com'
          fill_in 'password', with: 'baddpass'
          click_button 'SIGN IN'
        end
        it { is_expected.to have_title('Sign In') }
        it { is_expected.to have_selector('div.alert.alert-danger', text: 'Access Denied')}
      end

      describe 'with valid information' do
        before do
          fill_in 'email', with: admin.email
          fill_in 'password', with: admin.password
          click_button 'SIGN IN'
        end

        it { is_expected.to have_title 'Admin Panel'}
        it { is_expected.not_to have_title 'Admin Sign In'}

        describe 'Admin Index Page' do
          it { is_expected.to have_content 'APPOINTMENTS'}
          it { is_expected.to have_content 'DOCTORS' }
          it { is_expected.to have_content 'PATIENTS'}
          it { is_expected.to have_content 'DEPARTMENTS'}
          it { is_expected.to have_content "Today's Appointments" }

          describe 'admin department pages' do
            before do
              admin.save!
              clinic.save!
              department.save!
              doctor.save!
              click_link 'DEPARTMENTS'
            end
            it { is_expected.to have_link department.name }
            it { is_expected.to have_link 'Add Department' }

            describe 'Viewing departments' do
              before { click_link department.name }
              it { is_expected.to have_link department.doctors.first.full_name }
            end

            describe 'Should only see doctors in dept in same clinic' do
              let(:clinic2) { FactoryGirl.build(:clinic) }
              let(:doctor2) { FactoryGirl.create(:doctors,
                                                 first_name: 'Billiam',
                                                 email: 'doc2@doc2.com',
                                                 clinic_id: 2)}
              before do
                #comment out stub to call real api
                allow(clinic2).to receive(:call_google_api_for_location).and_return(
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
                clinic2.save!
                doctor.save!
                doctor2.save!
                click_link department.name
              end
              it { is_expected.not_to have_content doctor2.full_name }
              it { is_expected.to have_content doctor.full_name }
            end

            describe 'Adding Departments page' do
              before { click_link 'Add Department' }
              it { is_expected.to have_title 'Add Department' }
              it { is_expected.to have_content 'Name' }
              it { is_expected.to have_button 'Create' }

              describe 'cant add department with no name' do
                before { click_button 'Create' }
                it { is_expected.to have_title 'Add Department' }
                it { is_expected.to have_selector 'div.alert.alert-danger',
                     text: 'The form contains 1 error' }
                it { is_expected.to have_content "Name can't be blank"}
              end

              describe 'Adding a Department' do
                before do
                  fill_in 'department_name', with: 'newDept'
                  click_button 'Create'
                end
                it { is_expected.to have_content 'newDept' }

                describe 'Deleting a department' do
                  describe 'it should allow deleting a department with no doctors' do
                    before do
                      click_link 'newDept'
                      click_link 'Delete department'
                    end
                    it { is_expected.not_to have_content 'newDept' }
                  end
                  describe 'it should delete the department' do
                    before { click_link 'newDept' }
                    it 'should change the department count' do
                      expect do
                        click_link 'Delete department'
                      end.to change(Department, :count).by(-1)
                    end
                  end
                  describe 'Cannot delete departments with doctors' do
                    before do
                      click_link department.name
                      click_link 'Delete department'
                    end
                    it { is_expected.to have_selector 'div.alert.alert-danger',
                         text: 'Cannot delete a department with doctors' }
                  end
                  describe 'Invalid delete should not change Department count' do
                    before { click_link department.name }
                    it 'should not delete department count' do
                      expect { click_link 'Delete department' }.not_to change(Department, :count)
                    end
                  end
                  describe 'it should not delete the department' do
                    before do
                      click_link department.name
                      click_link 'Delete department'
                    end
                    it 'should change the department count' do
                      expect do
                        click_link 'Delete department'
                      end.not_to change(Department, :count)
                    end
                  end
                end
              end
            end
          end

          describe 'admin doctors pages' do
            describe 'browse doctors' do
              before do
                department.save!
                doctor.save!
                click_link 'DOCTORS'
              end
              it { is_expected.to have_title('Doctors') }
              it { is_expected.to have_link('Add Doctor') }
              it { is_expected.to have_content('Search') }
            end

            describe 'can only see doctors in own clinic' do
              let(:clinic2) { FactoryGirl.create(:clinic) }
              let(:doctor2) { FactoryGirl.create(:doctors, clinic_id: 2,
                                              email: 'docEmailTest.@test.com',
                                              first_name: 'healthier')}
              before do
                clinic2.save!
                department.save!
                doctor.save!
                doctor2.save!
                click_link 'DOCTORS'
              end
              it { is_expected.not_to have_text doctor2.full_name}
            end

            describe 'Add Doctor' do
              before  do
                department.save!
                click_link 'DOCTORS'
                click_link 'Add Doctor'
              end
              describe 'with invalid information' do
                before { click_button 'Create' }
                it { is_expected.to have_text('The form contains 4 errors') }
                it { is_expected.to have_selector('div.field_with_errors') }
                it { is_expected.to have_title('New Doctor') }
              end

              describe 'with valid information' do
                before do
                  fill_in 'doctor_first_name', with: 'Boos'
                  fill_in 'doctor_last_name', with: 'Radley'
                  fill_in 'doctor_email', with: 'boo@radley.com'
                  select 'Oncology', from: 'doctor_department_id'
                end
                it 'should create a new doctor' do
                  expect do
                    click_button 'Create'
                  end.to change(Doctor, :count).by(1)
                end
                describe 'Sends confirmation email when creating a doctor' do
                  before { click_button 'Create' }
                  it { expect(last_email.to).to include('boo@radley.com') }
                end
              end
            end
          end

          describe 'admin patient pages' do
            before do
              patient.save
              doctor.save
              click_link 'PATIENTS'
            end

            it { is_expected.to have_title 'Patients' }
            it { is_expected.to have_content 'Search' }

            describe 'Adding a patient' do
              before { click_link 'Add Patient' }
              describe 'with invalid information' do
                before { click_button 'Create' }
                it { is_expected.to have_title 'New Patient' }
                it { is_expected.to have_selector 'div.alert.alert-danger', text: 'Error Creating Patient'}
              end
              describe 'with valid information' do
                before do
                  fill_in 'patient_first_name', with: 'Boo'
                  fill_in 'patient_last_name',  with: 'Radley'
                  fill_in 'patient_email', with: 'boo@radley.com'
                  fill_in 'patient_birthday', with: '1962-12-12'
                  fill_in 'patient_social_security_number', with: '122-11-2211'
                  choose  'patient_sex_0'
                  fill_in 'patient_address1', with: '123 W main st'
                  fill_in 'patient_city', with: 'Phoenix'
                  fill_in 'patient_state', with: 'AZ'
                  fill_in 'patient_zipcode', with: '12345'
                  select doctor.full_name, from: 'doctor_doctor_id'
                end
                it 'should create a patient' do
                  expect do
                    click_button 'Create'
                  end.to change(Patient, :count).by(1)
                end

                describe 'after creating patient' do
                  before { click_button 'Create' }

                  it { is_expected.to have_title('Patients') }
                  it { is_expected.to have_selector('div.alert.alert-success', text: 'Patient Created') }
                  it { expect(last_email.to).to include('boo@radley.com') }
                end
              end
            end
          end

          describe 'appointments' do
            let(:appointment_request) { FactoryGirl.create(:appointment_request)}
            let(:appointment2) { FactoryGirl.create(:appointment,
             appointment_time: appointment_request.appointment_time + 1.hours )}
            before do
              patient.save!
              doctor.save!
              appointment2.save
            end
            describe 'Accepting appointments' do
              before { click_link 'APPOINTMENTS' }

              it { is_expected.to have_selector 'div.alert.alert-warning', text: 'Appointments waiting for approval'}
              it { is_expected.to have_link 'Appointment Requests' }

              describe 'appointment approval page' do
                before { click_link 'Appointment Requests' }
                it { is_expected.to have_content appointment_request.date_time_ampm }

                describe 'Seeing other appointment times' do
                  before do
                    click_link appointment_request.date_time_ampm
                  end
                  it { is_expected.to have_content appointment2.doctor.full_name}
                end

                describe 'approving the appointment' do
                  before do
                    reset_email
                    appointment_request.patient.email
                    click_link 'Approve'
                  end
                  it { is_expected.not_to have_content appointment_request.
                       date_time_ampm }
                  it 'should set request attribute to false' do
                    expect(appointment_request.reload.request).to eq(false)
                  end
                  it 'should send an email' do
                    # email_thread = appointment_request.email_confirmation_to_patient(:approve)
                    # email_thread.join
                    expect(all_emails_to).to include([appointment_request.patient.email])
                  end
                end

                describe 'Denying the appointment' do
                  before do
                    appointment.patient.email
                    click_link 'Deny'
                  end
                  it { is_expected.not_to have_content appointment_request.
                       appointment_time.strftime('%m-%e-%y %I:%M%p') }
                  it 'should send an email' do
                    expect(all_emails_to).to include([appointment.patient.email])
                  end
                end

                describe 'Denying appointment deletes record' do
                  it { expect { click_link 'Deny'}.
                       to change(Appointment, :count) }
                end
              end
            end

            describe 'Appointment delays' do
              let(:patient2) { FactoryGirl.create(:patient,
                                                  first_name: 'patient2',
                                                  email: 'patient2@example.com',
                                                  pid: Random.rand(200000),
                                                  social_security_number: '123-99-8151') }
              let(:appointment)  { FactoryGirl.create(:appointment_today) }
              let(:appointment2) {
                FactoryGirl.create(:appointment_today,
                                   patient_id: 2,
                                   appointment_time: appointment.appointment_time + 1.hour) }
              before do
                patient.save!
                patient2.save!
                appointment.save!
                appointment2.save!
                clinic.save!
                click_link 'APPOINTMENTS'
                click_link 'Manage Delays'
              end
              describe 'Appointment delay page' do
                it { is_expected.to have_content appointment.appointment_delayed_time.
                     strftime('%I:%M%p') }
                it { is_expected.to have_content appointment.doctor.full_name }
                it { is_expected.to have_button 'Update' }
              end
              describe 'Delaying only one appointment' do
                before do
                  device.save!
                  select '15', from: 'delay_0_0'
                end
                it { expect do
                       click_button 'Update_0_0'
                       appointment.reload
                     end.to change(appointment, :appointment_delayed_time) }

                describe 'should show changed time' do
                  before { click_button 'Update_0_0' }
                  it { is_expected.to have_content (appointment.appointment_time.
                                               strftime('%M').to_i + 15) % 60}
                  describe 'it should send an email' do
                    before do
                      reset_email
                      click_button 'Update_0_0'
                      appointment.patient.email
                    end
                   it ' should send an email to affected patient' do
                      # email_thread = appointment.send_delay_email
                      # email_thread.join
                      expect(all_emails_to).to include([appointment.patient.email])
                   end
                  end
                  describe 'not checking box should not delay other appointment' do
                    it { expect do
                      click_button 'Update_0_0'
                      appointment2.reload
                    end.to change(appointment2, :appointment_delayed_time) }
                  end
                end
              end
              describe 'Delaying all subsequent appointments of the day' do
                before do
                  select '15', from: 'delay_0_0'
                  check 'check_all_0_0'
                end
                it { expect do
                       click_button 'Update_0_0'
                       appointment2.reload
                end.to change(appointment2, :appointment_delayed_time) }
                it { expect do
                  click_button 'Update_0_0'
                  appointment.reload
                end.to change(appointment, :appointment_delayed_time) }

                describe 'should email all patients affects' do
                  before do
                    reset_email
                    click_button 'Update_0_0'
                    appointment.patient.email
                    appointment2.patient.email
                  end
                  it ' should send an email to changed patient' do
                    expect(all_emails_to).to include([appointment.patient.email])
                  end
                  it ' should send an email to other patient patient' do
                    expect(all_emails_to).to include([appointment2.patient.email])
                  end
                end
              end
            end
          end
        end

        describe 'signing out' do
          before { click_link 'Sign Out' }
          it { is_expected.to have_content 'Sign In' }
        end
      end
    end
  end

  #separated due to swtich to webkit from rack
  describe 'Browse appointments', :js => true do
    before do
      doctor.save!
      patient.save!
      appointment.save!
      admin.save!
      visit root_path
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'SIGN IN'
      click_link 'APPOINTMENTS'
      click_link 'Browse Appointments'
      fill_in 'appointment_day', with: 3.days.from_now.strftime('%F')
      click_button 'Submit'
    end


    #first test fails randomly, complains doctor is nil. Doesnt matter which is first
    it { is_expected.to have_selector('.day_appointments') }
    it { is_expected.to have_content 'Select Date' }
    it { is_expected.to have_content 'Time' }

    it { is_expected.to have_content Doctor.first.full_name }
    it { is_expected.to have_content appointment.time_am_pm }

    describe 'show appointment' do
      before { click_link('0') }
      it { is_expected.to have_text(appointment.description) }

      describe 'editing appointment' do
        #TODO fix
        # describe 'with invalid information' do
        #   before do
        #     click_link('Edit Appointment')
        #     fill_in 'appointment_datetime', with: '12:45'
        #     click_button('Update')
        #   end
        #   it { should have_selector('div.alert.alert-danger', text: 'Invalid parameters in update') }
        #   it { should have_title 'Edit Appointment' }
        # end
        describe 'with valid information' do
          before  do
            click_link('Edit Appointment')
            fill_in 'desc_text', with: 'updated description'
            click_button('Update')
          end
          it { is_expected.to have_selector('div.alert.alert-success', text: 'Appointment was successfully updated.') }
          describe 'verify edited appointment' do
            before { visit admin_appointment_path(admin, appointment) }
            it { is_expected.to have_text('updated description') }
          end
        end

        describe 'delete appointment' do
          before do
            visit edit_admin_appointment_path(admin, appointment)
            click_link 'Delete Appointment'
          end
          it { is_expected.to have_selector('div.alert.alert-warning', text: 'Appointment deleted') }
        end

        describe 'deleting appointment should change Appointment count' do
          before { visit edit_admin_appointment_path(admin, appointment) }
          #TODO find out why this is not changing count
          it do
            expect do
              click_link 'Delete Appointment'
              Appointment.all.reload
            end.to change(Appointment, :count)
          end
        end
      end
    end
  end

  #separated for webkit -> rack

  describe 'Creating Appointments' do
    before do
      doctor.save!
      patient.save!
      appointment.save!
      admin.save!
      clinic.save!

      visit root_path
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'SIGN IN'

      click_link 'APPOINTMENTS'
      click_link 'Add Appointment'

    end
    describe 'invalid appointment creation - date in past' do
      before do
        fill_in 'appointment_date', with: 3.days.ago.strftime('%F')
        click_button 'Schedule'
      end
      it { is_expected.to have_selector('div.alert.alert-danger',
                                text: 'Date/Time must be set in the future.') }
      it { is_expected.to have_title('New Appointment')}
    end


    describe 'valid appointment creation' do
      before do
        fill_in 'appointment_date', with: 3.days.from_now.strftime('%F')
        click_button 'Schedule'
      end
      it { is_expected.to have_selector('div.alert.alert-success', text: 'Appointment Created') }
      it { is_expected.to have_title 'Browse Appointments' }

    end

  end

  describe 'searching for patients', :js => true do
    before do
      doctor.save!
      patient.save!
      admin.save!

      visit root_path
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'SIGN IN'

      click_link 'PATIENTS'
    end
    describe 'when patient not found' do
      before do
        fill_in 'patient_last_name', with: '2342d'
        click_button 'Search'
      end
      it { is_expected.to have_selector 'div.alert.alert-warning', text: 'No records found'}
    end
    describe 'when patient found' do
      before do
        fill_in 'patient_last_name', with: patient.last_name
        click_button 'Search'
      end
      it { is_expected.to have_link '1' }
      it { is_expected.to have_content patient.full_name }
    end

    describe 'search is not case sensitive' do
      before do
        fill_in 'patient_last_name', with: patient.last_name.upcase
        click_button 'Search'
      end
      it { is_expected.to have_link '1' }
      it { is_expected.to have_content patient.full_name }
    end
    describe 'editing patient' do
      before do
        fill_in 'patient_last_name', with: patient.last_name
        click_button 'Search'
        click_link '1'
        click_link 'Edit'
        fill_in 'patient_first_name', with: 'Joseph'
        fill_in 'patient_last_name', with: 'Smith'
        click_button 'Update'
        patient.reload
      end
      it { is_expected.to have_title('Patients') }
      it { is_expected.to have_selector('div.alert.alert-success', text: 'Patient Successfully Updated') }
#      specify {full_name(patient).should be 'Joseph Smith'} not working on webkit driver
    end

    describe 'deleting patient' do
      before do
        fill_in 'patient_last_name', with: patient.last_name
        click_button 'Search'
        click_link '1'
        click_link 'Edit'
      end

      #TODO does not seem to change count
      it 'should delete the patient' do
        expect do
          click_link 'Delete Patient'
          Patient.all.reload
        end.to change(Patient, :count)
      end
      describe 'after deleting patient' do
        before { click_link 'Delete Patient' }

        it { is_expected.to have_title 'Patients' }
        it { is_expected.to have_no_content 'Boo Radley' }
        it { is_expected.to have_selector('div.alert.alert-warning', text: 'Patient deleted') }
      end
    end
  end

  describe 'searching for doctors', :js => true do
    before do
      department.save!
      doctor.save!
      patient.save!
      admin.save!

      visit root_path
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'SIGN IN'

      click_link 'DOCTORS'
    end

    describe 'when doctor not found' do
      before do
        fill_in 'doctor_last_name', with: '2342d'
        click_button 'Search'
      end
      it { is_expected.to have_selector 'div.alert.alert-warning', text: 'No records found'}
    end
    describe 'when doctor found' do
      before do
        fill_in 'doctor_last_name', with: doctor.last_name
        click_button 'Search'
      end
      it { is_expected.to have_link '1' }
      it { is_expected.to have_content doctor.full_name }
    end

    describe 'search is not case sensitive' do
      before do
        fill_in 'doctor_last_name', with: doctor.last_name.upcase
        click_button 'Search'
      end
      it { is_expected.to have_link '1' }
      it { is_expected.to have_content doctor.full_name }
    end

    describe 'search is not case sensitive for departments' do
      before do
        fill_in 'doctor_department', with: doctor.department_name.upcase
        click_button 'Search'
      end
      it { is_expected.to have_link '1' }
      it { is_expected.to have_content doctor.full_name }

      describe 'Editing doctor' do
        before  do
          click_link '1'
          click_link 'Edit'
        end

        describe 'with invalid info' do
          before do
            fill_in 'doctor_first_name', with: ''
            click_button 'Update'
          end
          it { is_expected.to have_selector 'div.alert.alert-danger', text: 'Invalid Parameters Entered' }
        end
        describe 'with valid info' do
          before do
            fill_in 'doctor_phone_number', with: '000-000-0000'
            click_button 'Update'
          end
          it { is_expected.to have_content 'Doctor Successfully Updated'}
        end
      end

      describe 'Deleting doctor' do
        before do
          click_link '1'
          click_link 'Edit'
        end
        #TODO Not detecting count change
        it 'should delete the doctor' do
          expect do
            click_link 'Delete Doctor'
            Doctor.all.reload
          end.to change(Doctor, :count)
        end

        describe 'after deleting doctor' do
          before { click_link 'Delete Doctor' }
          it { is_expected.to have_selector('div.alert.alert-warning', text: 'Doctor deleted') }
          it { is_expected.to have_no_content 'Boos Radley' }
        end
      end
    end
  end
end

