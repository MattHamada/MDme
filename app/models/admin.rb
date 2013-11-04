class Admin < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

  private

  def create_remember_token
    self.remember_token = Patient.encrypt(Patient.new_remember_token)
  end

end
