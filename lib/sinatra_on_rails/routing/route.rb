# frozen_string_literal: true

require_relative '../action_dispatcher'
require_relative 'route_helper'

module SinatraOnRails
  module Routing
    class Route
      HTTP_REQUEST_BODY_VERBS = %i[post put delete].freeze

      def initialize(app)
        @app = app
      end

      def draw(method, args)
        options = args.extract_options!
        options[:via] = method
        register(*args, options)
      end

      private

      attr_reader :app

      def register(path, options = {})
        define_route(path, options)
        route_helper.define_helper(path, options)
      end

      def define_route(path, options)
        app.public_send(options[:via], path) do
          options[:format] && content_type(options[:format])

          body = request.body.read
          if HTTP_REQUEST_BODY_VERBS.include?(options[:via]) && body.present? && body.start_with?('{')
            self.params = JSON.parse(body).merge(params)
          end

          ActionDispatcher.dispatch(self, options[:to])
        end
      end

      def route_helper
        @_route_helper ||= RouteHelper.new(app)
      end
    end
  end
end
