# frozen_string_literal: true

require_relative 'mapper'
require_relative 'routing/formatter'
require_relative 'routing/inspector'

module SinatraOnRails
  class Routes
    attr_reader :routes

    def initialize(application)
      @application = application
      @routes = []
    end

    def draw(&block)
      mapper.instance_exec(&block)
      application.helpers(Routing::RouteHelper.routes)
    end

    def print
      inspector = Routing::Inspector.new(routes)
      inspector.format(Routing::Formatter.new)
    end

    private

    attr_reader :application

    def mapper
      @_mapper ||= Mapper.new(application)
    end
  end
end
