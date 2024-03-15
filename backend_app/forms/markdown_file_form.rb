# frozen_string_literal: true
require 'json_schemer'

module BackendApp
  module Forms
    # Define a schema for file metadata validation
    class MarkdownFileForm
      SCHEMA_PATH = File.join(File.dirname(__FILE__), '..', '..', 'schemas', 'markdown_file.json')

      def self.validate(file_metadata)
        schema = JSON.parse(File.read(SCHEMA_PATH))
        schemer = JSONSchemer.schema(schema)

        schemer.valid?(file_metadata)
      end
    end
  end
end
