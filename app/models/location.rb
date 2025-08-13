class Location < ApplicationRecord
    has_many :historical_solar_records

    validates :name, presence: true, uniqueness: true
    validates :latitude, :longitude, presence: true

    before_validation :geocode, if: -> { name.present? && latitude.blank? }

    private

    def geocode
        results = Geocoder.search(name)
        if results.present?
            self.latitude = results.first.latitude
            self.longitude = results.first.longitude
        else
            errors.add(:base, "Could not find coordinates for this location")
        end
    end
end
