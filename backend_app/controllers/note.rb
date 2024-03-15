# frozen_string_literal: true

require_relative './app'

module BackendApp
  # Note API routing
  class App < Roda
    route('note') do |routing|
      # POST /note - Create a new note
      routing.post do
        note_params = JSON.parse(routing.body.read)
        note = Note.create_note(note_params) # Assuming `create_note` takes a hash of parameters
        response.status = 201 # HTTP status code for created resource
        { message: 'Note created', note_id: note.id }.to_json
      end

      # GET /note/:id - Retrieve a specific note
      routing.get String do |note_id|
        note = Note.find_by_id(note_id)
        if note
          note.attributes.to_json
        else
          response.status = 404
          { message: 'Note not found' }.to_json
        end
      end

      # PUT /note/:id - Update a specific note
      routing.put String do |note_id|
        note_params = JSON.parse(routing.body.read)
        note = Note.find_by_id(note_id)
        if note
          note.update_note(note_params)
          { message: 'Note updated' }.to_json
        else
          response.status = 404
        end
      end

      # DELETE /note/:id - Delete a specific note
      routing.delete String do |note_id|
        note = Note.find_by_id(note_id)
        if note
          note.delete_note
          { message: 'Note deleted' }.to_json
        else
          response.status = 404
        end
      end

      # GET /note - Retrieve all notes
      routing.get do
        notes = Note.all_notes.map(&:values).to_json
        if notes
          response.status = 200
          notes
        else
          response.status = 404
        end
      end
    end
  end
end
