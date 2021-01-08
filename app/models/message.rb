class Message < ApplicationRecord
  validates :content, presence: true#, length: {minimum: 10, maximum: 2000}
  
  validates :chef_id, presence: true

  belongs_to :chef

  def self.most_recent
    order(:created_at)#.last(3)
  end
  
end