# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.3.1'
gem 'coffee-rails', '~> 4.2'
gem 'config', '~> 1.7.0'
gem 'devise', '~> 4.7.1'
gem 'devise-bootstrap-views', '~> 1.1.0'
gem 'enum_help', '~> 0.0.17'
gem 'faraday', '~> 0.15.4'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.3.3'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'
gem 'ransack', '~> 2.1.1'
gem 'sass-rails', '~> 5.0'
gem 'slim', '~> 4.0.1'
gem 'slim-rails', '~> 3.2.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'week_of_month', '~> 1.2.6'
gem 'will_paginate', '~> 3.1.0'
gem 'pg', '>= 0.18', '< 2.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'mysql2', '>= 0.4.4', '< 0.6.0'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'bullet', '~> 5.9.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry', '~> 0.12.2'
  gem 'pry-byebug', '~> 3.7.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'pry-rescue', '~> 1.5.0'
  gem 'pry-stack_explorer', '~> 0.4.9.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
