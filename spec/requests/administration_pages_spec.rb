require 'spec_helper'

describe "AdministrationPages" do
  let(:clinic) { FactoryGirl.create(:clinic) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:appointment) { FactoryGirl.create(:appointment) }
  let(:doctor) { FactoryGirl.create(:doctor) }
  let(:department) { FactoryGirl.create(:department) }
  let(:patient) { FactoryGirl.create(:patient) }
  subject { page }
  before { switch_to_subdomain('admin') }

  describe 'root signin page' do
    before { visit root_path }

    it { should have_title('Sign In')}
    it { should have_content('Admin Sign In')}

    describe 'Forgot Password Page' do
      before do
        click_link 'Forgot Password'
      end
      it { should have_content 'Email' }
      it { should have_title 'Forgot Password' }

      describe 'resetting password' do
        before do
          fill_in 'Email', with: admin.email
          click_button 'Submit'
        end
        it { should have_content 'An email has been sent containing your new password'}
        it 'Email should be sent to user' do
          last_email.to.should include(admin.email)
        end
      end
    end

    describe 'signing in' do
      describe 'need to be signed in to get to admin pages' do
        before { visit admins_path }
        it { should have_content 'Sign In' }
      end
      describe 'wih invalid information' do
        before do
          fill_in 'Email', with: 'wrong@example.com'
          fill_in 'Password', with: 'baddpass'
          click_button 'Sign in'
        end
        it { should have_title('Sign In') }
        it { should have_selector('div.alert.alert-danger', text: 'Access Denied')}
      end

      describe 'with valid information' do
        before do
          fill_in 'Email', with: admin.email
          fill_in 'Password', with: admin.password
          click_button 'Sign in'
        end

        it { should have_title 'Admin Panel'}
        it { should_not have_title 'Admin Sign In'}

        describe 'Admin Index Page' do
          it { should have_content 'Manage Appointments'}
          it { should have_content 'Manage Doctors' }
          it { should have_content 'Manage Patients'}
          it { should have_content "Today's Appointments" }

          describe 'admin doctors pages' do
            describe 'browse doctors' do
              before do
                department.save!
                doctor.save!
                click_link 'Manage Doctors'
              end
              it { should have_title('Doctors') }
              it { should have_link('Add Doctor') }
              it { should have_content(doctor.full_name) }
              it { should have_content(doctor.department.name) }
            end

            describe 'can only see doctors in own clinic' do
              let(:clinic2) { FactoryGirl.create(:clinic) }
              let(:doctor2) { FactoryGirl.create(:doctor, clinic_id: 2,
                                              email: 'docEmailTest.@test.com',
                                              first_name: 'healthier')}
              before do
                clinic2.save!
                department.save!
                doctor.save!
                doctor2.save!
                click_link 'Manage Doctors'
              end
              it { should_not have_content(doctor2.full_name)}
            end

            describe 'Add Doctor' do
              before  do
                department.save!
                click_link 'Manage Doctors'
                click_link 'Add Doctor'
              end
              describe 'with invalid information' do
                before { click_button 'Create' }
                it { should have_text('The form contains 4 errors') }
                it { should have_selector('div.field_with_errors') }
                it { should have_title('New Doctor') }
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
                  it { last_email.to.should include("boo@radley.com") }
                end

                describe 'Editing doctor' do
                  before  do
                    click_button 'Create'
                    click_link '0'
                  end

                  describe 'with invalid info' do
                    before do
                      fill_in 'doctor_first_name', with: ''
                      click_button 'Update'
                    end
                    it { should have_selector 'div.alert.alert-danger', text: 'Invalid Parameters Entered' }
                  end
                  describe 'with valid info' do
                    before do
                      fill_in 'doctor_phone_number', with: '000-000-0000'
                      click_button 'Update'
                    end
                    it { should have_content 'Doctor Successfully Updated'}
                  end
                end

                describe 'Deleting doctor' do
                  before do
                    click_button 'Create'
                    click_link '0'
                  end
                  it 'should delete the doctor' do
                    expect do
                      click_link 'Delete Doctor'
                    end.to change(Doctor, :count).by(-1)
                  end

                  describe 'after deleting doctor' do
                    before { click_link 'Delete Doctor' }
                    it { should have_selector('div.alert.alert-warning', text: 'Doctor Successfully Deleted') }
                    it { should_not have_content 'Boos Radley' }
                  end
                end
              end
            end
          end

          describe 'admin patient pages' do
            before do
              patient.save
              doctor.save
              click_link 'Manage Patients'
            end

            it { should have_title 'Patients' }
            it { should have_content patient.full_name }
            it { should have_content patient.doctor.full_name }

            describe 'Adding a patient' do
              before { click_link 'Add Patient' }
              describe 'with invalid information' do
                before { click_button 'Create' }
                it { should have_title 'Create Patient' }
                it { should have_selector 'div.alert.alert-danger', text: 'Error Creating Patient'}
              end
              describe 'with valid information' do
                before do
                  fill_in 'patient_first_name', with: 'Boo'
                  fill_in 'patient_last_name',  with: 'Radley'
                  fill_in 'patient_email', with: 'boo@radley.com'
                  select doctor.full_name, from: 'doctor_doctor_id'
                end
                it 'should create a patient' do
                  expect do
                    click_button 'Create'
                  end.to change(Patient, :count).by(1)
                end

                describe 'after creating patient' do
                  before { click_button 'Create' }

                  it { should have_title('Patients') }
                  it { should have_content 'Boo Radley' }
                  it { should have_selector('div.alert.alert-success', text: 'Patient Created') }
                  it { last_email.to.should include("boo@radley.com") }

                  describe 'editing patient' do
                    before do
                      click_link '0'
                      fill_in 'patient_first_name', with: 'Joseph'
                      fill_in 'patient_last_name', with: 'Smith'
                      click_button 'Update'
                    end
                    it { should have_title('Patients') }
                    it { should have_content('Joseph Smith') }
                    it { should have_selector('div.alert.alert-success', text: 'Patient Successfully Updated') }
                  end

                  describe 'deleting patient' do
                    before { click_link '0' }

                    it 'should delete the patient' do
                      expect do
                        click_link 'Delete Patient'
                      end.to change(Patient, :count).by(-1)

                    end
                    describe 'after deleting patient' do
                      before { click_link 'Delete Patient' }

                      it { should have_title 'Patients' }
                      it { should_not have_content 'Boo Radley' }
                      it { should have_selector('div.alert.alert-warning', text: 'Patient Deleted') }
                    end
                  end

                end


              end
            end
          end

          describe 'appointments' do
            let(:appointment_request) { FactoryGirl.create(:appointment_request)}
            let(:appointment2) { FactoryGirl.create(:appointment,
             appointment_time: appointment_request.appointment_time + 1.hour, )}
            before do
              patient.save!
              doctor.save!
              appointment_request.save!
              appointment2.save
            end
            describe 'Accepting appointments' do
              before { click_link 'Manage Appointments' }

              it { should have_selector 'div.alert.alert-warning', text: 'Appointments waiting for approval.'}
              it { should have_link 'Appointment Requests' }

              describe 'appointment approval page' do
                before { click_link 'Appointment Requests' }
                it { should have_content appointment_request.appointment_time.strftime('%m-%e-%y %I:%M%p') }

                describe 'Seeing other appointment times' do
                  before do
                    click_link appointment_request.appointment_time.strftime('%m-%e-%y %I:%M%p')
                  end
                  it { should have_content appointment2.doctor.full_name}
                end

                describe 'approving the appointment' do
                  before { click_link 'Approve' }
                  it { should_not have_content appointment_request.
                       appointment_time.strftime('%m-%e-%y %I:%M%p') }
                  it 'should set request attribute to false' do
                    appointment_request.reload.request.should eq(false)
                  end
                end

                describe 'Denying the appointment' do
                  before { click_link 'Deny' }
                  it { should_not have_content appointment_request.
                       appointment_time.strftime('%m-%e-%y %I:%M%p') }
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
                                                  email: 'patient2@example.com') }
              let(:appointment)  { FactoryGirl.create(:appointment_today) }
              let(:appointment2) {
                FactoryGirl.create(:appointment_today,
                                   patient_id: 2,
                                   appointment_time: appointment.appointment_time + 1.hour) }
              before do
                patient2.save!
                appointment.save!
                appointment2.save!
                click_link 'Manage Appointments'
                click_link 'Manage Delays'
              end
              describe 'Appointment delay page' do
                it { should have_content appointment.appointment_delayed_time.
                     strftime('%I:%M%p') }
                it { should have_content appointment.doctor.full_name }
                it { should have_button 'Update' }
              end
              describe 'Delaying only one appointment' do
                before do
                  select '15', from: 'delay_0_0'
                end
                it { expect do
                       click_button 'Update_0_0'
                       appointment.reload
                     end.to change(appointment, :appointment_delayed_time) }

                describe 'should show changed time' do
                  before { click_button 'Update_0_0' }
                  it { should have_content (appointment.appointment_time.
                                               strftime('%M').to_i + 15) % 60}
                #describe 'it should send an email' do
                #  before { click_button 'Update_0_0' }
                #  it { last_email.to.should include(appointment.patient.email) }
                #end

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
              end

            end
          end

        end

        describe 'signing out' do
          before { click_link 'Sign Out' }
          it { should have_content 'Scheduling Simplified' }
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
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Sign in'

      click_link "Manage Appointments"
      fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
      click_button 'Submit'
      #wait_until { find('#day_appointments') }
    end


    it { should have_selector('.day_appointments') }
    it { should have_content "Select Date" }
    it { should have_content 'Time' }

    it { should have_content Doctor.first.full_name }
    it { should have_content appointment.appointment_time.strftime("%h")}

    describe 'show appointment' do
      before { click_link('0') }
      it { should have_text(appointment.description) }

      describe 'editing appointment' do
        describe 'with invalid information' do
          before do
            click_link('Edit Appointment')
            fill_in 'date_day', with: 3.days.ago.strftime('%F')
            click_button('Update')
          end
          it { should have_selector('div.alert.alert-danger', text: 'Invalid parameters in update') }
          it { should have_title 'Edit Appointment' }
        end
        describe 'with valid information' do
          before  do
            click_link('Edit Appointment')
            fill_in 'desc_text', with: 'updated description'
            click_button('Update')
          end
          it { should have_selector('div.alert.alert-success', text: 'Appointment was successfully updated.') }
          describe 'verify edited appointment' do
            before { visit appointment_path(appointment) }
            it { should have_text('updated description') }
          end
        end

        describe 'delete appointment' do
          before do
            visit edit_appointment_path(appointment)
            click_link 'Delete Appointment'
          end
          it { should have_selector('div.alert.alert-warning', text: 'Appointment deleted') }
            #expect { click_link 'Delete Appointment' }.to change(Appointment, :count).by(-1)

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

      visit root_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Sign in'

      click_link "Manage Appointments"
      click_link "Add Appointment"

    end
    describe 'invalid appointment creation - date in past' do
      before do
        fill_in 'appointments_date', with: 3.days.ago.strftime("%F")
        click_button 'Find open times'
        click_button 'Schedule'
      end
      it { should have_selector('div.alert.alert-danger',
                                text: 'Date/Time must be set in the future.') }
      it { should have_title('New Appointment')}
    end


    describe 'valid appointment creation' do
      before do
        fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
        click_button 'Find open times'
        click_button 'Schedule'
      end
      it { should have_selector('div.alert.alert-success', text: 'Appointment Created') }
      it { should have_title 'Browse Appointments' }

    end

  end
end

