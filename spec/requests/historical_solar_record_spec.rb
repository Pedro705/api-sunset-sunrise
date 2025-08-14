require "rails_helper"

RSpec.describe "Historical Solar Record", type: :request do
    describe "GET /historical_solar_record" do
        it "Returns the historical solar record for a location and a date range" do
            get '/historical_solar_record', params: {
                location: "Coimbra",
                start_date: '2025-08-10',
                end_date: '2025-08-13'
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:ok)
        
            expected_output = [
                {
                    "date" => "2025-08-10",
                    "sunrise" => "05:08:25",
                    "sunset" => "19:08:26",
                    "golden_hour" => "19:08:26"
                },
                {
                    "date" => "2025-08-11",
                    "sunrise" => "05:08:24",
                    "sunset" => "19:08:10",
                    "golden_hour" => "19:08:10"
                },
                {
                    "date" => "2025-08-12",
                    "sunrise" => "05:08:22",
                    "sunset" => "19:08:54",
                    "golden_hour" => "19:08:54"
                },
                {
                    "date" => "2025-08-13",
                    "sunrise" => "05:08:20",
                    "sunset" => "19:08:36",
                    "golden_hour" => "19:08:36"
                }
            ]
            
            expect(JSON.parse(response.body)).to eq(expected_output)
        end

        it "Some records do not have data" do
            get '/historical_solar_record', params: {
                location: "Antartic",
                start_date: '2025-08-01',
                end_date: '2025-08-03'
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:ok)
        
            expected_output = [
                {
                    "date" => "2025-08-01",
                    "sunrise" => "",
                    "sunset" => "",
                    "golden_hour" => ""
                },
                {
                    "date" => "2025-08-02",
                    "sunrise" => "11:08:48",
                    "sunset" => "12:08:12",
                    "golden_hour" => "12:08:12"
                },
                {
                    "date" => "2025-08-03",
                    "sunrise" => "11:08:29",
                    "sunset" => "13:08:23",
                    "golden_hour" => "13:08:23",
                },
            ]
            
            expect(JSON.parse(response.body)).to eq(expected_output)
        end

        it "Missing params" do
            get '/historical_solar_record', headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end

        it "Only include location param" do
            get '/historical_solar_record', params: {
                location: "Coimbra",
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end

        it "Only include start date param" do
            get '/historical_solar_record', params: {
                start_date: '2025-08-10',
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end

        it "Only include end date param" do
            get '/historical_solar_record', params: {
                end_date: '2025-08-10',
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end

        it "Location should not exist" do
            get '/historical_solar_record', params: {
                location: 'Location does not exist',
                start_date: '2025-08-10',
                end_date: '2025-08-10',
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:not_found)
        end

        it "Start date is not valid" do
            get '/historical_solar_record', params: {
                location: 'Coimbra',
                start_date: 'Date is not valid',
                end_date: '2025-08-10',
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end

        it "End date is not valid" do
            get '/historical_solar_record', params: {
                location: 'Coimbra',
                start_date: 'Date is not valid',
                end_date: '2025-08-10',
            }, headers: { 'Accept' => 'application/json' }

            expect(response).to have_http_status(:bad_request)
        end
    end
end
