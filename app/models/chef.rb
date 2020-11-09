class Chef < ApplicationRecord
  before_save { self.email = email.downcase }
  
  validates :chefname, presence: true, length: {minimum: 2, maximum: 20}

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  
  validates :password, presence: true, length: {minimum: 5, maximum: 20}, allow_nil: true

  has_secure_password

  has_many :recipes
end