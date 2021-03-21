require 'csv'

class Recipe < ApplicationRecord
  validates :name,        presence: true, length: {minimum: 5, maximum: 100}
  
  validates :description, presence: true, length: {minimum: 10, maximum: 2000}
  
  validates :chef_id,     presence: true
  
  default_scope -> { order(updated_at: :desc) }
  
  belongs_to :chef
  
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  
  def chefname
    Chef.find(chef_id)
  end
  
  def self.to_csv
    CSV.generate(headers: true) do |csv|
      attributes = %w{ name description chefname }
      csv << attributes
      
      all.each do |recipe|
        # csv << recipe.attributes.values_at(*attributes)
        csv << attributes.map { |attr| recipe.send(attr) }
      end
    end
  end
end