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

ActiveRecord::Schema.define(version: 20131104175101) do

  create_table "appointments", force: true do |t|
    t.integer  "doctor_id"
    t.integer  "patient_id"
    t.datetime "appointment_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["doctor_id", "patient_id"], name: "index_appointments_on_doctor_id_and_patient_id"

  create_table "doctors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctors", ["email"], name: "index_doctors_on_email", unique: true
  add_index "doctors", ["remember_token"], name: "index_doctors_on_remember_token"

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "last_name"
    t.string   "remember_token"
  end

  add_index "patients", ["email"], name: "index_patients_on_email", unique: true
  add_index "patients", ["remember_token"], name: "index_patients_on_remember_token"

end
