class Trip < ApplicationRecord
  # singular because trip belongs to only a single driver
  belongs_to :driver
  
  # singular because trip belongs to only a single passenger
  belongs_to :passenger
end