require 'spec_helper'

describe 'Patient Pages', :js => true do
  subject { page }
  let(:clinic) { FactoryGirl.build(:clinic) }
  let(:patient) { FactoryGirl.create(:patient, clinics: [clinic]) }
  let(:doctor) { FactoryGirl.create(:doctor) }
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
    switch_to_subdomain('www')
    visit root_path
    click_link 'SIGN IN'
  end
  #needed to clear cookies or signin link dissapears
  after :each do
      page.execute_script("window.sessionStorage.clear()")
  end

  describe 'Sign in Page' do
    it 'should have these items on page' do
      expect(page).to have_button 'SIGN IN'
      expect(page).to have_link 'forgot password?'
      expect(page).to have_field 'signin_email'
      expect(page).to have_field 'signin_password'
    end

    describe 'signin with invalid information' do
      describe 'with invalid credentials' do
        before do
          fill_in 'signin_email',    with: 'boo@radley.com'
          fill_in 'signin_password', with: patient.password
          click_button 'SIGN IN'
        end
        it 'should still be on sign on page with flash error' do
          expect(page).to have_text 'forgot password?'
          expect(page).to have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination'
        end
        # it { is_expected.to have_text 'forgot password?'}
        # it { is_expected.to have_selector 'div.alert.alert-danger', text: 'Invalid email/password combination'}
      end
      describe 'with valid credentials' do
        before do
          patient.save!
          sign_in_patient
        end
        it 'should have links for sign out but not sign in' do
          expect(page).to have_text 'Sign Out'
          expect(page).not_to have_text 'SIGN IN'
        end
        # it { is_expected.to have_link 'Sign Out' }
        # it { is_expected.not_to have_link 'SIGN IN' }
      end
    end
  end
  describe 'patient homepage' do
    before { sign_in_patient }
    it 'should have these items' do
      expect(page).to have_link 'MY PROFILE'
      expect(page).to have_link 'MY RESULTS'
      expect(page).to have_link 'MY APPOINTMENTS'
      expect(page).to have_text patient.first_name
      expect(page).to have_text patient.last_name
      expect(page).to have_text patient.email
      expect(page).to have_text patient.home_phone
      expect(page).to have_text patient.work_phone
    end

    describe 'Upcoming appointment stats' do
      before do
        clinic.save
        doctor.save
      end
      describe 'with no upcoming appointment' do
        before { click_link 'MY PROFILE' }
        it { is_expected.to have_content 'No upcoming appointments' }
      end

      describe '3 hours left on appointment' do
        let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                        appointment_time: DateTime.now + 3.hours) }
        before do
          upcoming_appointment.save
          click_link 'MY PROFILE'
        end
        it { is_expected.to have_content 'No upcoming appointments' }
      end

      describe '50 minutes left on Appointment' do
        let(:upcoming_appointment) { FactoryGirl.create(:appointment,
                                                        appointment_time: Time.zone.now + 50.minutes) }
        describe 'progress bar present and green' do
          before do
            upcoming_appointment.save!
            click_link 'MY PROFILE'
            wait_for_ajax
          end
          it 'should have a progress bar at 51%' do
            expect(page).to have_selector 'div.progress-bar.progress-bar-success'
            expect(page.find('div.progress-bar.progress-bar-success')['style']).to match(/51%/)
          end
          it { is_expected.to have_selector 'div.progress-bar.progress-bar-success' }
        end
      end
    end
  end

  describe 'Editing Patient profile' do
    before do
      sign_in_patient
      sleep 1
      click_link 'edit profile'
    end
    it { is_expected.to have_text 'Edit Profile' }

    describe 'When no password entered' do
      before do
        click_button 'Update'
      end
      it 'should be on edit profile page', js: true do
        is_expected.to have_text 'Edit Profile'
      end
    end

    describe 'When field is invalid but gets to submit' do
      before do
        fill_in 'patient_birthday', with: 5
        fill_in 'patient_password', with: patient.password
        click_button 'Update'
        wait_for_ajax
        screenshot_and_open_image

      end
      it { is_expected.to have_selector 'div.alert.alert-danger', text: "Birthday can't be blank"}
    end

    describe 'Successful update should stick' do
      before do
        fill_in 'patient_first_name', with: 'James'
        fill_in 'patient_password', with: patient.password
        click_button 'Update'
      end
      it 'should show the update was successful and the new name shown' do
        expect(page).to have_selector 'div.alert.alert-success', text: 'patient updated'
        expect(page).to have_text 'James'
      end
      # it { is_expected.to have_selector 'div.alert.alert-success', text: 'patient updated' }
      # it { is_expected.to have_text 'James'}
    end
  end
end