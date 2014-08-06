source 'http://rubygems.org'

ruby '2.0.0'
gem 'rails', '4.1.0'
gem 'sass-rails', '~> 4.0.0'
gem 'jquery-rails', '3.0.4'
gem 'bcrypt-ruby', '~> 3.1.5'
gem 'uglifier', '>= 2.2.1'
gem 'bootstrap-sass', '~> 3.1.1.1'

# nokogiri 1.6.2 segmentation faults when running rspec
gem 'nokogiri', '1.6.1'

gem 'pg', '0.17.0'
gem 'highcharts-rails', '~> 4.0.1'
gem "kaminari", "~> 0.15.1"
gem 'simple_calendar', '~> 1.1.3'
gem 'rqrcode', '0.4.2'
gem 'jbuilder', '~> 2.1.3'
gem "pg_search", "~> 0.7.0"
gem "bootstrap-datepicker-rails", "~> 1.1.1.8"
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
gem "skylight"

group :test do
  gem 'capybara', '~> 2.2.1'
  gem 'poltergeist', '~> 1.5.0'
  gem 'database_cleaner', '1.2.0'
end

group :test, :development do
  gem 'rspec-rails', '~> 3.0.0.beta2'
  gem "factory_girl_rails", "~> 4.4.1"
end

group :development do
  gem 'thin', '~> 1.6.2'
  gem 'spring', '~> 1.1.2'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :production do
  gem 'unicorn', '~> 4.8.3'
  gem 'rails_12factor'
end
