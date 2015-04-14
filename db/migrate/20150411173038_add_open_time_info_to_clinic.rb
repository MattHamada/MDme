class AddOpenTimeInfoToClinic < ActiveRecord::Migration
  def change
    add_column :clinics, :sunday_open_time,           :string
    add_column :clinics, :sunday_close_time,          :string
    add_column :clinics, :is_open_sunday,             :boolean

    add_column :clinics, :monday_open_time,           :string
    add_column :clinics, :monday_close_time,          :string
    add_column :clinics, :is_open_monday,             :boolean

    add_column :clinics, :tuesday_open_time,          :string
    add_column :clinics, :tuesday_close_time,         :string
    add_column :clinics, :is_open_tuesday,            :boolean

    add_column :clinics, :wednesday_open_time,        :string
    add_column :clinics, :wednesday_close_time,       :string
    add_column :clinics, :is_open_wednesday,          :boolean

    add_column :clinics, :thursday_open_time,         :string
    add_column :clinics, :thursday_close_time,        :string
    add_column :clinics, :is_open_thursday,           :boolean

    add_column :clinics, :friday_open_time,           :string
    add_column :clinics, :friday_close_time,          :string
    add_column :clinics, :is_open_friday,             :boolean

    add_column :clinics, :saturday_open_time,         :string
    add_column :clinics, :saturday_close_time,        :string
    add_column :clinics, :is_open_saturday,           :boolean

    add_column :clinics, :appointment_time_increment, :integer
  end
end

