# routes/current_event.rb

require 'json'

module Todo
  module Routes
    class CurrentEvents < Roda
      plugin :all_verbs
      plugin :request_headers

      route do |r|
        r.on do
          auth_header = r.headers['Authorization']
          requestor = JWTCredential.decode_jwt(auth_header)

          # GET api/current_event/
          r.get do
            time = Time.now
            puts "time: #{time}"
            events = EventService.find(requestor, time)
            response.status = 200
            { success: true, data: events }.to_json
            rescue EventService::ForbiddenError => e
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

