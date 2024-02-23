# routes/location.rb

require 'json'

module Todo
  module Routes
    class Locations < Roda
      plugin :all_verbs
      plugin :request_headers

      route do |r|
        r.on do
          auth_header = r.headers['Authorization']
          requestor = JWTCredential.decode_jwt(auth_header)

          # GET api/location/list_all
          r.on 'list_all' do
            r.get do
              locations = LocationService.list_all(requestor)
              response.status = 200
              { success: true, data: locations }.to_json
            rescue LocationService::ForbiddenError => e
              response.status = 403
              { error: 'Forbidden', details: e.message }.to_json
            end
          end

          r.on String do |location_id|


            r.on do
              # GET api/location/:id
              r.get do
                location = LocationService.get(requestor, location_id)
                response.status = 200
                { success: true, data: location }.to_json
              rescue LocationService::ForbiddenError => e
                response.status = 403
                { error: 'Forbidden', details: e.message }.to_json
              end
              # PUT api/location/:id
              r.put do
                request_body = JSON.parse(r.body.read)

                LocationService.update(requestor, location_id, request_body)
                response.status = 200
                { success: true, message: 'Location updated'}.to_json
              rescue LocationService::LocationNotFoundError => e
                response.status = 404
                { error: 'Location not found', details: e.message }.to_json
              rescue LocationService::ForbiddenError => e
                response.status = 403
                { error: 'Forbidden', details: e.message }.to_json
              end

              # DELETE api/location/:id
              r.delete do
                LocationService.remove(requestor, location_id)
                response.status = 200
                { success: true, message: 'Location deleted' }.to_json
              rescue LocationService::ForbiddenError => e
                response.status = 403
                { error: 'Forbidden', details: e.message }.to_json
              rescue JSON::ParserError => e
                response.status = 400
                { error: 'Invalid JSON', details: e.message }.to_json
              rescue Sequel::NoMatchingRow => e
                response.status = 404
                { error: 'Location not found', details: e.message }.to_json
              end
            end
          end

          # GET api/location
          r.get do
            locations = LocationService.list(requestor)
            response.status = 200
            { success: true, data: locations }.to_json
          rescue LocationService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # POST api/location
          r.post do
            request_body = JSON.parse(r.body.read)
            location = LocationService.create(requestor, request_body)
            response.status = 201
            { success: true, message: 'Location created', location_info: location.attributes }.to_json
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue LocationService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end
        rescue JWTCredential::ArgumentError => e
          response.status = 400
          response.write({ error: 'Token error', details: e.message }.to_json)
          r.halt
        rescue StandardError => e
          response.status = 500
          response.write({ error: 'Internal server error', details: e.message }.to_json)
          r.halt
        end
      end
    end
  end
end
