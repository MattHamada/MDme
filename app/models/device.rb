class Device < ActiveRecord::Base
  belongs_to :patient
  validates_uniqueness_of :token, :scope => :patient_id

  def self.test_notifications
    destination = Device.first.token
    data = {:appointment_id => 1, :type => 'READY', message: 'Your appointment with Dr. Denson is ready.'}
    GCM.send_notification(destination, data)
  end
end
