class Doctor < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}
  validates :password, length: { minimum: 6 }, unless: :is_admin_applying_update

  attr_accessor :is_admin_applying_update
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"


  before_save { self.email = email.downcase }
  before_create :create_remember_token


  has_many :appointments
  has_many :patients
  belongs_to :department

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end

  private

    def create_remember_token
      self.remember_token = Patient.encrypt(Patient.new_remember_token)
    end

end
