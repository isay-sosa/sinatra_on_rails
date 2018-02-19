# frozen_string_literal: true

require_relative 'route'
require_relative 'routeable'

module SinatraOnRails
  module Routing
    class SimpleRoute
      include Routeable

      def initialize(mapper, *args)
        @mapper = mapper
        @options = args.extract_options!.dup
        @path = build_path(args.pop)
        @method = args.pop
      end

      def draw_route
        Route.new(mapper.app).draw(method, ["#{parent_path}#{path}", options])
      end

      private

      attr_reader :mapper, :options, :method, :path

      def build_path(path)
        return path if path.start_with?('/')
        "/#{path}"
      end

      def parent_path
        resources_path(mapper.resource_levels)
      end
    end
  end
end
