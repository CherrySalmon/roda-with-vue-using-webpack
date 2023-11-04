# frozen_string_literal: true

source 'https://rubygems.org'

gem 'figaro', '~>1.2'
gem 'foreman'
gem 'puma'
gem 'rake'
gem 'roda'
gem 'sequel'
gem 'tilt'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'pry'
  gem 'sqlite3', '~> 1.4'
end

group :development do
  gem 'rubocop'
end