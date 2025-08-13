module Api
    class SunriseSunset
        include HTTParty
        base_uri ENV["SUNRISE_SUNSET_API_URL"]

        headers "Content-Type" => "application/json", "Accept" => "application/json"

        def self.historial_sunrise_sunset(latitude, longitude, start_date, end_date)
            options = { query: {
                lat: latitude,
                lng: longitude,
                timezone: "UTC",
                date_start: format_date(start_date),
                date_end: format_date(end_date)
            } }.compact_blank

            response = get("/json", options)
            handle_response(response)
        end

        def self.handle_response(response)
            if response.success?
                JSON.parse(response.body)["results"]
            else
                raise Error.new(response.message, details: response.body, status_code: response.code)
            end
        rescue JSON::ParserError
            raise Error.new("Invalid JSON response", details: response.body, status_code: :internal_server_error)
        rescue => e
            raise Error.new("Unexpected error: #{e.message}", status_code: e.status_code)
        end

        def self.format_date(date)
            Date.parse(date.to_s).strftime("%Y-%m-%d")
        rescue
            raise Error.new("Invalid date format.", status_code: :bad_request)
        end
    end
end
