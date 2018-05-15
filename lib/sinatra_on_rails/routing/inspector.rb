# frozen_string_literal: true

module SinatraOnRails
  module Routing
    class Inspector
      def initialize(routes)
        @routes = routes
      end

      def format(formatter)
        routes = collect_routes

        if routes.none?
          formatter.no_routes(collect_routes)
          return formatter.result
        end

        formatter.header(routes)
        formatter.section(routes)
        formatter.result
      end

      private

      def collect_routes
        @_collect_routes ||= @routes.collect do |route|
          { name: route[2], verb: route[1][:via].to_s.upcase, path: route[0], reqs: route[1][:to] }
        end
      end
    end
  end
end
