# frozen_string_literal: true

require_relative './require_app'

namespace :db do
  task :config do
    require('sequel')
    require_app('config')
  end

  desc 'Migrate the database to the latest version'
  task migrate: [:config] do
    Sequel.extension :migration

    # Set up the migration path
    migration_path = File.expand_path('backend_app/db/migration', __dir__)
    print('migration_path:', migration_path)

    # Run the migrations
    Dir.glob("#{migration_path}/*.rb").each { |file| require file }
    Sequel::Migrator.run(BackendApp::Api.db, migration_path)
  end

  desc 'Delete dev or test database file'
  task drop: [:config] do
    @app = BackendApp::Api
    if @app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    db_filename = "backend_app/db/store/#{@app.environment}.db"
    FileUtils.rm(db_filename)
    puts "Deleted #{db_filename}"
  end
end
