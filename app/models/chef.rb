class Chef < ApplicationRecord
  validates :chefname, presence: true
  validates :email, presence: true
  validates_length_of :chefname, minimum: 2, maximum: 20
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  has_many :recipes
end