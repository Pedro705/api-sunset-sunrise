class HistoricalSolarRecord < ApplicationRecord
    include DateConcern

    belongs_to :location

    validates :date, presence: true
    validates :location_id, presence: true
    validates :date, uniqueness: { scope: :location_id }

    # Params validation are inside this method because we cant trust in the input
    # This method could be used in another place so i decided to validate here and not in the controller
    def self.get_historical_solar_records(location, start_date, end_date)
        start_date = validate_date_string(start_date)
        end_date = validate_date_string(end_date)
        raise ::Error.new("Must define start and end date", status_code: :bad_request) if start_date.blank? || end_date.blank?

        location_record = Location.find_or_create_by(name: location)
        raise ::Error.new("Location does not exists", status_code: :not_found) unless location_record.persisted?

        historical_records = HistoricalSolarRecord
            .where(location_id: location_record.id, date: start_date..end_date)
            .select(:date, :sunrise, :sunset, :golden_hour)
        historical_records_dates = historical_records.pluck(:date)

        range = (start_date..end_date).to_a
        missing_dates = range.reject { |date| historical_records_dates.include?(date) }

        # Opted to just reload the query, it should be fast for the case. We have indexes which improve a lot
        # We could just append the previous historical_records to the result from store_records_by_gap
        if missing_dates.any?
            store_records_by_gap(location_record, missing_dates.first, missing_dates.last, missing_dates)
            historical_records.reload
        end

        historical_records
    end

    # Note that the gap will always be the highest
    # We could have limit the gap, if exceed that limit we seprate in multiple API calls to avoid querying a huge dataset
    def self.store_records_by_gap(location, gap_start, gap_end, missing_dates)
        results = Api::SunriseSunset.historial_sunrise_sunset(location.latitude, location.longitude, gap_start, gap_end)

        results.each do |record_data|
            date = Date.parse(record_data["date"])

            # parse_time_with_date allow to set the date to the current date
            if missing_dates.include?(date)
                HistoricalSolarRecord.create!(
                    location_id: location.id,
                    date: date,
                    day_length: time_to_seconds(record_data["day_length"]),
                    sunrise: parse_time_with_date(record_data["sunrise"], date),
                    sunset: parse_time_with_date(record_data["sunset"], date),
                    first_light: parse_time_with_date(record_data["first_light"], date),
                    last_light: parse_time_with_date(record_data["last_light"], date),
                    dawn: parse_time_with_date(record_data["dawn"], date),
                    dusk: parse_time_with_date(record_data["dusk"], date),
                    solar_noon: parse_time_with_date(record_data["solar_noon"], date),
                    golden_hour: parse_time_with_date(record_data["golden_hour"], date),
                    timezone: record_data["timezone"],
                    utc_offset: record_data["utc_offset"]
                )
            end
        end
    rescue => e
        Rails.logger.error "Failed to create historical solar record for #{location.name} - #{gap_start} to #{gap_end}: #{e.message}"
        raise e
    end
end
