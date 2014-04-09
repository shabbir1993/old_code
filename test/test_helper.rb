ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'minitest/mock'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  extend MiniTest::Spec::DSL

  class << self
    remove_method :describe
  end
end

MiniTest::Spec.register_spec_type( /Controller$/, ActionController::TestCase )
