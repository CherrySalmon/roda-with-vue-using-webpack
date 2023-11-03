require 'sequel'
require 'figaro'
require 'roda'
require 'logger'
module Todo
  # Configuration for the API
  class Api < Roda
    plugin :environments

    # load config secrets into local environment variables (ENV)
    Figaro.application = Figaro::Application.new(
      environment: environment, # rubocop:disable Style/HashSyntax
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load

    # Make the environment variables accessible to other classes
    def self.config = Figaro.env
    db_url = ENV['DATABASE_URL']
    DB = Sequel.connect(db_url, logger: Logger.new($stderr))
    def self.DB = DB # rubocop:disable Naming/MethodName
  end
end
