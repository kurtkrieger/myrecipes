class Chef < ApplicationRecord
  before_save { self.email = email.downcase }
  has_secure_password
  
  validates :chefname, presence: true
  validates_length_of :chefname, minimum: 2, maximum: 20

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  
  validates :password, presence: true
  validates_length_of :password, minimum: 5, maximum: 20
  
  has_many :recipes
end