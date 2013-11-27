class Patient < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }, unless: :is_admin_applying_update

  attr_accessor :is_admin_applying_update

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  belongs_to  :doctor
  has_many :appointments

  has_secure_password


  def full_name
    "#{first_name} #{last_name}"
  end


  #TODO refactor session key encryption out of patient model
  def Patient.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Patient.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = Patient.encrypt(Patient.new_remember_token)
    end

end
