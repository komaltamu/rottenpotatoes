class Movie < ActiveRecord::Base
  def self.unique_ratings
    self.distinct.pluck(:rating)
end
    def self.ratings
      Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
    end
end