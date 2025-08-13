class HistoricalSolarRecordController < ApplicationController
    def index
        solar_record = HistoricalSolarRecord.get_historical_solar_records(
            historical_params["location"],
            historical_params["start_date"],
            historical_params["end_date"]
        )

        results = solar_record.map do |record|
            {
                date: record.date,
                sunrise: record.sunrise.strftime("%H:%m:%S"),
                sunset: record.sunset.strftime("%H:%m:%S"),
                golden_hour: record.sunset.strftime("%H:%m:%S")
            }
        end

        render json: results, status: :ok
    rescue => e
        # Maybe here we could avoid showing server side errors
        render json: { error: e.message }
    end

    private

    def historical_params
        params.permit(:location, :start_date, :end_date)
    end
end
