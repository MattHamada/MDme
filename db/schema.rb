# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140607192214) do

  create_table "admins", force: true do |t|
    t.string   "email"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.integer  "clinic_id"
  end

  add_index "admins", ["clinic_id"], name: "index_admins_on_clinic_id"
  add_index "admins", ["email"], name: "index_admins_on_email"
  add_index "admins", ["remember_token"], name: "index_admins_on_remember_token"

  create_table "appointments", force: true do |t|
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.datetime "appointment_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "request",                  default: true
    t.datetime "appointment_delayed_time"
    t.integer  "clinic_id"
  end

  add_index "appointments", ["appointment_time"], name: "index_appointments_on_appointment_time"
  add_index "appointments", ["clinic_id"], name: "index_appointments_on_clinic_id"
  add_index "appointments", ["doctor_id", "patient_id"], name: "index_appointments_on_doctor_id_and_patient_id"
  add_index "appointments", ["request"], name: "index_appointments_on_request"

  create_table "clinics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "clinics", ["slug"], name: "index_clinics_on_slug"

  create_table "clinics_patients", id: false, force: true do |t|
    t.integer "clinic_id"
    t.integer "patient_id"
  end

  add_index "clinics_patients", ["clinic_id"], name: "index_clinics_patients_on_clinic_id"
  add_index "clinics_patients", ["patient_id"], name: "index_clinics_patients_on_patient_id"

  create_table "departments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clinic_id"
    t.string   "slug"
  end

  add_index "departments", ["clinic_id"], name: "index_departments_on_clinic_id"
  add_index "departments", ["slug"], name: "index_departments_on_slug"

  create_table "doctors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone_number"
    t.string   "degree"
    t.string   "alma_mater"
    t.text     "description"
    t.string   "slug"
    t.integer  "clinic_id"
  end

  add_index "doctors", ["clinic_id"], name: "index_doctors_on_clinic_id"
  add_index "doctors", ["department_id"], name: "index_doctors_on_department_id"
  add_index "doctors", ["email"], name: "index_doctors_on_email", unique: true
  add_index "doctors", ["remember_token"], name: "index_doctors_on_remember_token"
  add_index "doctors", ["slug"], name: "index_doctors_on_slug"

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "last_name"
    t.string   "remember_token"
    t.integer  "doctor_id"
    t.string   "slug"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "api_key"
    t.string   "address"
    t.string   "work_phone"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.integer  "pid"
    t.date     "dob"
  end

  add_index "patients", ["api_key"], name: "index_patients_on_api_key"
  add_index "patients", ["doctor_id"], name: "index_patients_on_doctor_id"
  add_index "patients", ["email"], name: "index_patients_on_email", unique: true
  add_index "patients", ["pid"], name: "index_patients_on_pid", unique: true
  add_index "patients", ["remember_token"], name: "index_patients_on_remember_token"
  add_index "patients", ["slug"], name: "index_patients_on_slug"

end
