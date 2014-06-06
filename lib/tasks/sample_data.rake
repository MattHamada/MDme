# Author: Matt Hamada
# Copyright MDme 2014
#
# Populates database with users, doctors, appointments, used for testing
# Appointments made for 1-5 days ahead of when script run
# usage: rake db:populate and rake db:populate_appointments for additional appointments
#


namespace :db do
  desc 'Fill database with sample data'
  task populate: :environment do
    #create first doctor and patient and appointment and clinic
    c = Clinic.create!(name: 'MDME clinic')
    p = Patient.create!(first_name: 'John',
                    last_name: 'Doeseph',
                    email: 'user@example.com',
                    password: 'AndrewMattMDME3000!',
                    password_confirmation: 'AndrewMattMDME3000!',
                    doctor_id: '1')
    p.clinics << c
    Department.create!(name: 'Pediatrics',
                       clinic_id: 1)
    Department.create!(name: 'Anaesthesia',
                       clinic_id: 1)
    Department.create!(name: 'Internal Medicine',
                       clinic_id: 1)
    Department.create!(name: 'Oncology',
                       clinic_id: 1)
    Doctor.create!(first_name: 'Healthy',
                   last_name: 'doctorson',
                   email: 'doctor@example.com',
                   password: 'AndrewMattMDME3000!',
                   password_confirmation: 'AndrewMattMDME3000!',
                   department_id: 1,
                   degree: 'MD',
                   alma_mater: 'Harvard',
                   phone_number: '121-124-6722',
                   description: Faker::Lorem.paragraph(4),
                   clinic_id: 1)
    Appointment.create!(patient_id: 1,
                        doctor_id: 1,
                        request: false,
                        appointment_time: rand_time_with_intervals(1.day.from_now),
                        clinic_id: 1)

    Admin.create!(email: 'admin@example.com',
                  password: 'AndrewMattMDME3000!',
                  password_confirmation: 'AndrewMattMDME3000!',
                  clinic_id: 1)


    #fill with other sample patients
    60.times do |n|
      name = Faker::Name.name.split(' ')
      email = "examplePatient#{n+1}@example.com"
      password = 'AndrewMattMDME3000!'
      doctor_id = rand_int(1,6)
      p = Patient.create!(first_name: name[0],
                      last_name: name[1],
                      email: email,
                      password: password,
                      password_confirmation: password,
                      doctor_id: doctor_id)
      p.clinics << c
    end

    #sample doctors
    schools = ['Harvard', 'Yale', 'UCLA', 'UofA', 'Midwestern University', 'Tufts']
    6.times do |n|
      name = Faker::Name.name.split(' ')
      email = "exampleDoctor#{n+1}@example.com"
      password = 'AndrewMattMDME3000!'
      department_id = rand_int(1,4)
      phone_number = rand_int(0,9).to_s + rand_int(0,9).to_s + rand_int(0,9).to_s + '-' + rand_int(0,9).to_s +
                     rand_int(0,9).to_s + rand_int(0,9).to_s + '-' + rand_int(0,9).to_s + rand_int(0,9).to_s +
                     rand_int(0,9).to_s + rand_int(0,9).to_s
      degree = rand_int(0,1) == 1 ? 'DO': 'MD'
      alma_mater = schools[rand_int(0,5)]
          Doctor.create!(first_name: name[0],
                     last_name: name[1],
                     email: email,
                     password: password,
                     password_confirmation: password,
                     department_id: department_id,
                     phone_number: phone_number,
                     degree: degree,
                     alma_mater: alma_mater,
                     description: Faker::Lorem.paragraph(4),
                     clinic_id: 1)
    end

    #sample appointments
    60.times do |n|
      patient_id = n+1
      doctor_id = rand_int(1, 7)
      appointment_time = rand_time_with_intervals(3.days.from_now)
      #appointment_time.change(hour: (9..16).to_a.sample)
      #appointment_time.change(min: [00, 15, 30, 45].sample)
      request = (rand_int(0,2) == 1) ? true : false
      Appointment.create(patient_id: patient_id,
                          doctor_id: doctor_id,
                          appointment_time: appointment_time,
                          request: request,
                          description: Faker::Lorem.paragraph(4),
                          clinic_id: 1)
    end

  end

  task populate_appointments: :environment do

        #sample appointments
    100.times do |n|
      patient_id = rand_int(1,61)
      doctor_id = rand_int(1, 7)
      appointment_time = rand_time_with_intervals(5.days.from_now)
      #appointment_time.change(hour: (9..16).to_a.sample)
      #appointment_time.change(min: [00, 15, 30, 45].sample)
      request = (rand_int(0,2) == 1) ? true : false
      Appointment.create(patient_id: patient_id,
                         doctor_id: doctor_id,
                         appointment_time: appointment_time,
                         description: Faker::Lorem.paragraph(4),
                         request: request,
                         clinic_id: 1)
    end

  end
end

def rand_int(from, to)
  rand_in_range(from, to).to_i
end

def rand_price(from, to)
  rand_in_range(from, to).round(2)
end

def rand_time(end_time, start_time=Time.now+3.hours)
  Time.at(rand_in_range(start_time.to_f, end_time.to_f))
end

def rand_time_with_intervals(end_date, start_date=Date.tomorrow )
  day = (start_date..end_date).to_a.sample
  hour = (9..17).to_a.sample
  min = [00, 15, 30, 45].sample
  datetime = DateTime.new(day.year, day.month, day.day, hour, min)
end

def rand_in_range(from, to)
  rand * (to - from) + from
end
