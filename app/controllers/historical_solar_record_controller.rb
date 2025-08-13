class HistoricalSolarRecordController < ApplicationController
    def index
        solar_record = HistoricalSolarRecord.get_historical_solar_records(
            params[:location],
            params[:start_date],
            params[:end_date]
        )

        results = solar_record.map do |record|
            {
                date: record.date,
                sunrise: record.sunrise&.strftime("%H:%m:%S") || "",
                sunset: record.sunset&.strftime("%H:%m:%S") || "",
                golden_hour: record.sunset&.strftime("%H:%m:%S") || ""
            }
        end

        render json: results, status: :ok
    rescue => e
        render json: e.message, status: e.status_code
    end
end
