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

ActiveRecord::Schema.define(version: 20141217181335) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "remember_token",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest", limit: 255
    t.integer  "clinic_id"
  end

  add_index "admins", ["clinic_id"], name: "index_admins_on_clinic_id"
  add_index "admins", ["email"], name: "index_admins_on_email"
  add_index "admins", ["remember_token"], name: "index_admins_on_remember_token"

  create_table "appointments", force: :cascade do |t|
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.datetime "appointment_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "request",                              default: true
    t.datetime "appointment_delayed_time"
    t.integer  "clinic_id"
    t.boolean  "checked_in",                           default: false
    t.boolean  "inform_earlier_time"
    t.string   "access_key",               limit: 255
  end

  add_index "appointments", ["appointment_time"], name: "index_appointments_on_appointment_time"
  add_index "appointments", ["clinic_id"], name: "index_appointments_on_clinic_id"
  add_index "appointments", ["doctor_id", "patient_id"], name: "index_appointments_on_doctor_id_and_patient_id"
  add_index "appointments", ["request"], name: "index_appointments_on_request"

  create_table "clinics", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",         limit: 255
    t.string   "address1",     limit: 255
    t.string   "address2",     limit: 255
    t.string   "address3",     limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "zipcode",      limit: 255
    t.string   "country",      limit: 255
    t.string   "phone_number", limit: 255
    t.string   "fax_number",   limit: 255
    t.float    "ne_latitude"
    t.float    "ne_longitude"
    t.float    "sw_latitude"
    t.float    "sw_longitude"
  end

  add_index "clinics", ["name"], name: "index_clinics_on_name"
  add_index "clinics", ["slug"], name: "index_clinics_on_slug"

  create_table "clinics_patients", id: false, force: :cascade do |t|
    t.integer "clinic_id"
    t.integer "patient_id"
  end

  add_index "clinics_patients", ["clinic_id"], name: "index_clinics_patients_on_clinic_id"
  add_index "clinics_patients", ["patient_id"], name: "index_clinics_patients_on_patient_id"

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clinic_id"
    t.string   "slug",       limit: 255
  end

  add_index "departments", ["clinic_id"], name: "index_departments_on_clinic_id"
  add_index "departments", ["slug"], name: "index_departments_on_slug"

  create_table "devices", force: :cascade do |t|
    t.integer  "patient_id"
    t.string   "token",      limit: 255
    t.string   "platform",   limit: 255
    t.boolean  "enabled",                default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctors", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "email",               limit: 255
    t.string   "password_digest",     limit: 255
    t.string   "remember_token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone_number",        limit: 255
    t.string   "degree",              limit: 255
    t.string   "alma_mater",          limit: 255
    t.text     "description"
    t.string   "slug",                limit: 255
    t.integer  "clinic_id"
  end

  add_index "doctors", ["clinic_id"], name: "index_doctors_on_clinic_id"
  add_index "doctors", ["department_id"], name: "index_doctors_on_department_id"
  add_index "doctors", ["email"], name: "index_doctors_on_email", unique: true
  add_index "doctors", ["remember_token"], name: "index_doctors_on_remember_token"
  add_index "doctors", ["slug"], name: "index_doctors_on_slug"

  create_table "patients", force: :cascade do |t|
    t.string   "first_name",                       limit: 255
    t.string   "email",                            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",                  limit: 255
    t.string   "last_name",                        limit: 255
    t.string   "remember_token",                   limit: 255
    t.integer  "doctor_id"
    t.string   "slug",                             limit: 255
    t.string   "avatar_file_name",                 limit: 255
    t.string   "avatar_content_type",              limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "api_key",                          limit: 255
    t.string   "address",                          limit: 255
    t.string   "work_phone",                       limit: 255
    t.string   "home_phone",                       limit: 255
    t.string   "mobile_phone",                     limit: 255
    t.integer  "pid"
    t.date     "dob"
    t.string   "middle_initial",                   limit: 255, default: ""
    t.string   "name_prefix",                      limit: 255
    t.string   "name_suffix",                      limit: 255, default: ""
    t.date     "birthday"
    t.string   "encrypted_social_security_number", limit: 255, default: ""
    t.integer  "marital_status"
    t.string   "address1",                         limit: 255
    t.string   "address2",                         limit: 255
    t.string   "city",                             limit: 255
    t.string   "state",                            limit: 255
    t.string   "zipcode",                          limit: 255
    t.string   "work_phone_extension",             limit: 255
    t.integer  "preferred_daytime_phone"
    t.integer  "sex"
  end

  add_index "patients", ["api_key"], name: "index_patients_on_api_key"
  add_index "patients", ["doctor_id"], name: "index_patients_on_doctor_id"
  add_index "patients", ["email"], name: "index_patients_on_email", unique: true
  add_index "patients", ["pid"], name: "index_patients_on_pid", unique: true
  add_index "patients", ["remember_token"], name: "index_patients_on_remember_token"
  add_index "patients", ["slug"], name: "index_patients_on_slug"

end
