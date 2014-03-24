require 'spec_helper'

describe "Patient Pages" do
  subject { page }
  before { switch_to_subdomain('www') }
  let(:patient) { FactoryGirl.create(:patient) }

  describe 'need to be logged in to access patient pages' do
    before { visit patient_path(patient) }
    it { should have_content 'Scheduling Simplified' }
  end

  describe 'signing in' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign In') }

    describe 'with invalid information' do
      before { click_button 'Sign in' }
      it { should have_title 'Sign In' }
      it { should have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination'}
    end

    describe 'with valid information' do
      before do
        fill_in 'Email',    with: patient.email
        fill_in 'Password', with: 'Qwerty1'
        click_button 'Sign in'
      end
      it { should_not have_title 'Sign in' }
      it { should have_content 'Sign Out' }
      it { should have_title(full_name(patient)) }
      it { should_not have_link('Sign in', href: signin_path) }



      describe 'cannot view pages of another patient' do
        let(:patient2) { FactoryGirl.create(:patient,
                                            email: 'test2@test.com') }
        before do
          patient2.save!
          visit patient_path(patient2)
        end
        it { should have_content 'Scheduling Simplified' }
      end

      describe 'editing requests pages' do
        let(:appointment) { FactoryGirl.create(:appointment_request) }
        let(:doctor) { FactoryGirl.create(:doctor) }
        before do
          doctor.save
          appointment.save
          click_link 'Request an Appointment'
          click_link 'Edit Requests'
        end
        it { should have_content appointment.date_time_ampm }
        it { should have_content appointment.doctor.full_name }
        it { should have_link '1' }

        describe 'editing a request' do
          before do
            click_link '1'
            select '4:45 PM', from: 'time'
          end
          it { expect do
            click_button 'Update'
            appointment.reload
          end.to change(appointment, :appointment_time) }
        end

        describe 'deleting requests' do
          before do
            click_link '1'
            click_link 'Delete Request'
          end
          it { should_not have_content appointment.date_time_ampm }
        end

        describe 'should delete appointment request' do
          before do
            click_link '1'
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
        it { should have_link('sign in') }
      end
    end


    describe 'Forgot Password Page' do
      before do
        click_link 'Forgot Password'
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
      click_link 'sign in'
      fill_in 'Email', with: patient.email
      fill_in 'Password', with: 'Qwerty1'
      click_button 'Sign in'
      click_link 'Request an Appointment'
    end
    describe 'with invalid (past) date' do
      before do
        fill_in 'appointments_date', with: 3.days.ago.strftime("%F")
        click_button 'Find open times'
        click_button 'Request'
      end
      it { should have_selector 'div.alert.alert-danger', text: 'Time must be set in the future' }
    end

    describe 'with valid date' do
      before do
        fill_in 'appointments_date', with: 3.days.from_now.strftime("%F")
        click_button 'Find open times'
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
        click_link 'Request an Appointment'
      end
      it 'should not list doctor2 in available doctors' do
        find(:css, 'select#doctor_doctor_id').value.should_not eq 2
      end
    end
  end
end
