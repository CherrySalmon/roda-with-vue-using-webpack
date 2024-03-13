require 'google/apis/sheets_v4'
require 'googleauth'

def get_data_from_google_sheet(config={})
  service = Google::Apis::SheetsV4::SheetsService.new 
  service.authorization = get_google_auth

  values = service.get_spreadsheet_values(config[:sheet_id], config[:range]).values
  puts values
end

def get_google_auth
  scope = [Google::Apis::SheetsV4:: AUTH_SPREADSHEETS_READONLY]
  file = File.open("backend_app/config/service-account-file.json", 'r')
  authorization = Google::Auth::ServiceAccountCredentials.make_creds({:json_key_io=> file, :scope => scope})
end
  
config = {
    sheet_id: "1SGpK8G1dBmIhcn0unch6ow2AwQVAvxsJj3sslRyOqCs",
    range: "!A1:B5000"
}

get_data_from_google_sheet(config)