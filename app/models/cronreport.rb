class Cronreport < ApplicationRecord
  belongs_to :lookup
  has_many :cronreport_distributions
end