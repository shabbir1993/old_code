ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require "capybara/rails"
require 'capybara/poltergeist'

#removes sql from test output
ActiveRecord::Base.logger = nil

DatabaseCleaner.strategy = :truncation

Dir[Rails.root.join("test/support/**/*.rb")].each {|f| require f}

class MiniTest::Spec
  after { DatabaseCleaner.clean }
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  Capybara.javascript_driver = :poltergeist

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    DatabaseCleaner.clean
  end

  register_spec_type(/integration$/, self)
end

Turn.config.format = :outline
