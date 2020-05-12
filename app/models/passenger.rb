class Passenger < ApplicationRecord
  validates :name, presence: true
  validates :phone_num, presence: true

  has_many :trips

  def total_expenses
    total = 0
    self.trips.each do |trip|
      total += trip.cost
    end
    return total
  end

  def trip_request
    trip_date = Time.now
    trip_cost = rand(1..50)
    trip_driver_id = Driver.available_driver.id

    trip_info = {date: trip_date, cost: trip_cost, driver_id: trip_driver_id }
    return trip_info
  end
end
