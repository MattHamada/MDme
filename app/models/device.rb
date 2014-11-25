class Device < ActiveRecord::Base
  belongs_to :patient
  validates_uniqueness_of :token, :scope => :patient_id

  def self.test_notifications
    destination = Device.first.token
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(destination, data)
  end
end
