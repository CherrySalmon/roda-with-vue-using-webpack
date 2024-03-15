require_relative '../../require_app'
require_app

require 'rack/test'
require 'minitest/autorun'

# Setting the environment to 'test'
ENV['RACK_ENV'] = 'test'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    BackendApp::App
  end

  def setup
    Sequel::Model.db.tables.each do |table|
      Sequel::Model.db[table].truncate
    end
  end

  # Test POST /note
  def test_post_note
    note_params = { note_id: 'test1', content: 'This is a test note.' }
    post '/api/note', note_params.to_json, 'CONTENT_TYPE' => 'application/json'

    assert_equal 201, last_response.status
    assert_includes last_response.body, 'Note created'
  end

  # Test GET /note/:id
  def test_get_note
    Note.create(note_id: 'test2', content: 'Sample content')
    get '/api/note/test2'

    assert_equal 200, last_response.status
  end

  # Test GET /note/:id with non-existing id
  def test_get_note_not_found
    get '/api/note/non_existing_id'

    assert_equal 404, last_response.status
  end
end
