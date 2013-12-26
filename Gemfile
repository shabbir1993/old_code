source 'http://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'jquery-rails', '3.0.4'
gem 'coffee-rails', '~> 4.0.0'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'uglifier', '>= 2.2.1'
gem 'protected_attributes'

gem 'pg', '0.17.0'
gem 'paper_trail', '>= 3.0.0.beta1'
gem "kaminari", "~> 0.14.1"
gem "pg_search", "~> 0.7.0"
gem "bootstrap-datepicker-rails", "~> 1.1.1.8"
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"

group :test do
  gem "minitest", "~> 4.7"
  gem "mocha", "~> 0.14.0", require: false
  gem 'capybara', '2.1.0'
  gem "factory_girl_rails", "4.2.1"
  gem 'database_cleaner', "1.1.1"
  gem "turn", "~> 0.9.6"
  gem "poltergeist", "~> 1.4.1"
end

group :production do
  gem "thin", "~> 1.5.1"
  gem 'rails_12factor'
end
