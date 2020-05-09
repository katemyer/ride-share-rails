class Driver < ApplicationRecord
  # plural because many trips could be associated with this single driver
  has_many :trips
end
