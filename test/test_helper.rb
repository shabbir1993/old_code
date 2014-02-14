ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'capybara/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join("test/support/**/*.rb")].each {|f| require f}

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  extend MiniTest::Spec::DSL

  class << self
    remove_method :describe
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  Capybara.javascript_driver = :poltergeist

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

def use_javascript_driver
  Capybara.current_driver = Capybara.javascript_driver
end
