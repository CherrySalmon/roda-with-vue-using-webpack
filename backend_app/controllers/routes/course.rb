# routes/course.rb

require 'json'

module Todo
  module Routes
    class Courses < Roda
      plugin :all_verbs
      plugin :request_headers

      route do |r|
        r.on do
          auth_header = r.headers['Authorization']
          requestor = JWTCredential.decode_jwt(auth_header)

          # GET api/list_all
          r.on 'list_all' do
            r.get do
              courses = CourseService.list_all(requestor)
              response.status = 200
              { success: true, data: courses }.to_json
            rescue CourseService::ForbiddenError => e
              response.status = 403
              { error: 'Forbidden', details: e.message }.to_json
            end
          end

          r.on 'enroll' do
            # GET api/course/enroll - Retrieve enrollment information
            r.get String do |id|
              course_id = id
              enrollments = CourseService.get_enrollments(requestor, course_id)
              response.status = 200
              { success: true, data: enrollments }.to_json

            rescue CourseService::ForbiddenError => e
              response.status = 403
              { error: 'Forbidden', details: e.message }.to_json
            rescue CourseService::CourseNotFoundError => e
              response.status = 404
              { error: 'Course not found', details: e.message }.to_json
            end

            # PUT api/course/enroll - Update or add enrollments
            r.put String do |id|
              request_body = JSON.parse(r.body.read)
              course_id = id
              enrolled_data = request_body["enroll"] # Expects an array of {email: "email", roles: "role1,role2"}
              CourseService.update_enrollments(requestor, course_id, enrolled_data)
              response.status = 200
              { success: true, message: 'Enrollments updated' }.to_json
            rescue JSON::ParserError
              response.status = 400
              { error: 'Invalid JSON format' }.to_json
            rescue CourseService::CourseNotFoundError => e
              response.status = 404
              { error: 'Course not found', details: e.message }.to_json
            end
          end

          # GET api/course
          r.get do
            courses = CourseService.list(requestor)
            response.status = 200
            { success: true, data: courses }.to_json
          rescue CourseService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # POST api/course
          r.post do
            request_body = JSON.parse(r.body.read)
            course = CourseService.create(requestor, request_body)
            response.status = 201
            { success: true, message: 'Course created', course_info: course.attributes }.to_json
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue CourseService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # PUT api/course/:id
          r.put String do |course_id|
            request_body = JSON.parse(r.body.read)
            CourseService.update(requestor, course_id, request_body)
            response.status = 200
            { success: true, message: 'Course updated'}.to_json
          rescue CourseService::CourseNotFoundError => e
            response.status = 404
            { error: 'Course not found', details: e.message }.to_json
          rescue CourseService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          end

          # DELETE api/course/:id
          r.delete String do |course_id|
            CourseService.remove(requestor, course_id)
            response.status = 200
            { success: true, message: 'Course deleted' }.to_json
          rescue CourseService::ForbiddenError => e
            response.status = 403
            { error: 'Forbidden', details: e.message }.to_json
          rescue JSON::ParserError => e
            response.status = 400
            { error: 'Invalid JSON', details: e.message }.to_json
          rescue Sequel::NoMatchingRow => e
            response.status = 404
            { error: 'Course not found', details: e.message }.to_json
          end
        rescue JWTCredential::ArgumentError => e
          response.status = 400
          response.write({ error: 'Token error', details: e.message }.to_json)
          r.halt
        rescue => e
          response.status = 500
          response.write({ error: 'Internal server error', details: e.message }.to_json)
          r.halt
        end
      end
    end
  end
end
