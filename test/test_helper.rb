# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENV['RACK_ENV'] = 'test'
require 'sinatra_on_rails'

require 'minitest/autorun'
require 'rack/test'

class ApplicationTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Sinatra.app
  end

  class DummyApplication < SinatraOnRails::Application
  end
end
