# frozen_string_literal: true

require 'test_helper'
require 'sinatra_on_rails/utils/string'

module SinatraOnRails
  module Utils
    class StringTest < Minitest::Test
      def test_camelcase
        assert_equal('Class', 'class'.camelcase)
        assert_equal('ClassController', 'class_controller'.camelcase)
        assert_equal('::ClassController', '/class_controller'.camelcase)
        assert_equal('::ClassController', '/class_controller'.camelcase)
        assert_equal('Api::ClassController', 'api/class_controller'.camelcase)
        assert_equal('::Api::ClassController', '/api/class_controller'.camelcase)
        assert_equal('APi::V1::ClassController', 'a_pi/v1/class_controller'.camelcase)
        assert_equal('Api+v1::ClassController', 'api+v1/class_controller'.camelcase)
        assert_equal('Api::+v1::ClassControlleR', 'api/+v1/class_controlle_r'.camelcase)
      end

      def test_underscore
        assert_equal('class', 'Class'.underscore)
        assert_equal('some_thing', 'someThing'.underscore)
        assert_equal('class', 'CLASS'.underscore)
        assert_equal('class_controller', 'ClassController'.underscore)
        assert_equal('/class_controller', '::ClassController'.underscore)
        assert_equal('/class_controller', '/ClassController'.underscore)
        assert_equal('api/class_controller', 'Api::ClassController'.underscore)
        assert_equal('api/class_controller', 'Api/ClassController'.underscore)
        assert_equal('api/v1/class_controller', 'API::V1::ClassController'.underscore)
        assert_equal('a_pi/v1/class_controller', 'APi::V1::ClassController'.underscore)
        assert_equal('api/v1/class_controller', 'API/V1::ClassController'.underscore)
        assert_equal('api+v1/class_controller', 'API+V1::ClassController'.underscore)
        assert_equal('api/v1/_class_controller', 'API/V1::_ClassController'.underscore)
        assert_equal('api/+v1/class_controller', 'API::+V1::ClassController'.underscore)
        assert_equal('api/+v1/class_controlle_r', 'API::+V1::ClassControlleR'.underscore)
      end
    end
  end
end
