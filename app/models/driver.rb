class Driver < ApplicationRecord
  #validations
  validates :name, presence: true
  validates :vin, presence: true

  # relationship: plural because many trips could be associated with this single driver
  has_many :trips

  #Total Revenue Method
  #https://github.com/Ada-Developers-Academy/textbook-curriculum/blob/master/08-rails/model-logic.md
  #parameters: 
  #returns total
  def total_revenue()
    total_revenue = 0
    fee = 1.65
    trip_history = self.trips
    trip_history.each do |trip|
      if (trip.cost != nil) && (trip.cost > fee)
          total_revenue += (trip.cost - fee) * 0.8
      end
    end
    return total_revenue
  end #total_revenue method

  #Average Rating Method
  #parameters
  #returns average
  def average_rating()
    total_ratings = 0
    total_trips = 0
    average_rating = 0
    
    self.trips.each do |trip|
      # if trip cost is not nil, the trip is complete
      if trip.cost != nil 
        total_ratings += trip.rating
        total_trips += 1
      end
    end
    if total_trips > 0 
      average_rating = total_ratings.to_f / total_trips
    end
    return average_rating
  end #average_rating method

end #class
