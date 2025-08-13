class HistoricalSolarRecordController < ApplicationController
    def index
        # We could check the mandatory presence of the 3 params
        solar_record = HistoricalSolarRecord.get_historical_solar_records(
            params[:location],
            params[:start_date],
            params[:end_date]
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
end
