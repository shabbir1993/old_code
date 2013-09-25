ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require "capybara/rails"
require 'capybara/poltergeist'
require "active_support/testing/setup_and_teardown"

#removes sql from test output
ActiveRecord::Base.logger = nil

DatabaseCleaner.strategy = :truncation

Dir[Rails.root.join("test/support/**/*.rb")].each {|f| require f}

class MiniTest::Spec
  before { DatabaseCleaner.clean }
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false, inspector: true)
  end
  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 5

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  register_spec_type(/integration$/, self)
end

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end

require 'mocha/setup'
