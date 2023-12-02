# frozen_string_literal: true

require 'roda'
require 'json'

module BackendApp
  # Backend web app controller
  class App < Roda
    # app using
    plugin :render
    plugin :public, root: 'dist'

    # api using
    plugin :all_verbs
    plugin :halt
    plugin :multi_route

    # rubocop:disable Metrics/BlockLength
    route do |r|
      r.public
      r.on 'api' do
        r.multi_route

        r.get do
          response['Content-Type'] = 'application/json'
          response.status = 200
          'Welcome to ruby roda vue world'
        end
      end

      # app part
      r.root do
        File.read(File.join('dist', 'index.html'))
      end

      r.get String do |_parsed_request|
        File.read(File.join('dist', 'index.html'))
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
