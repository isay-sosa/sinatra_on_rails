# frozen_string_literal: true

require_relative 'mapper'
require_relative 'routing/formatter'
require_relative 'routing/inspector'

module SinatraOnRails
  class Routes
    attr_reader :routes

    def initialize(app_class)
      @app_class = app_class
      @routes = []
    end

    def draw(&block)
      mapper.instance_exec(&block)
    end

    def print
      inspector = Routing::RoutesInspector.new(routes)
      inspector.format(Routing::ConsoleFormatter.new)
    end

    private

    attr_reader :app_class

    def mapper
      @_mapper ||= Mapper.new(app_class)
    end
  end
end
