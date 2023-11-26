# frozen_string_literal: true
require 'dry-validation'

module Todo
  module Forms
    # Define a schema for file metadata validation
    class MarkdownFileSchema < Dry::Validation::Contract
      params do
        required(:file_name).filled(:string)
        required(:file_type).filled(:string)
      end
    end
  end
end
