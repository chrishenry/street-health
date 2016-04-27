source 'https://rubygems.org'

gem 'dotenv-rails'

gem 'rails', '4.2.5.1'
gem 'sass'

# Use Bootstrap for frontend
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Pagination
gem 'will_paginate', '3.0.7'
gem 'bootstrap-will_paginate', '0.0.10'

gem 'bower-rails'
gem "foreman"
gem 'angularjs-rails'
gem 'angular-rails-templates'

gem 'soda-ruby', :require => 'soda'
gem 'geocoder'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Get coverage reports
  gem 'simplecov'

  gem 'faker', '1.4.2'
end

group :test do
  gem "webmock"
  gem "vcr"
end

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Angularjs gems
  gem "rspec-rails", "~> 3.4.2"
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "database_cleaner"
  gem "selenium-webdriver"

  # Angular testing
  gem 'teaspoon-jasmine'
  gem 'phantomjs'

end

group :production do
  gem 'pg', '0.17.1'
  gem 'rails_12factor'
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
  gem 'puma', '3.2.0'
end
