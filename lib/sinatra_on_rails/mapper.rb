# frozen_string_literal: true

require_relative 'routing/namespace'
require_relative 'routing/simple_route'
require_relative 'routing/resource'
require_relative 'routing/resources'

module SinatraOnRails
  class Mapper
    ACTIONS = %i[index create update new edit destroy show].freeze
    ACTIONS_WITH_HTTP_VERBS = {
      create: :post,
      destroy: :delete,
      edit: :get,
      index: :get,
      new: :get,
      show: :get,
      update: :put
    }.freeze
    REQUEST_BODY_HTTP_VERBS = %i[post put delete].freeze

    attr_accessor :resource_levels, :module_levels
    attr_reader :app

    def initialize(app)
      @app = app
      @module_levels = []
      @resource_levels = []
    end

    %i[get post put delete].each do |method|
      define_method(method) do |*args|
        Routing::SimpleRoute.new(self, *[method].concat(args)).draw_route
      end
    end

    def namespace(namespace, &block)
      Routing::Namespace.new(self, namespace, &block).draw_routes
    end

    def resources(*resources, &block)
      Routing::Resources.new(self, *resources, &block).draw_routes
    end

    def resource(*resource, &block)
      Routing::Resource.new(self, *resource, &block).draw_routes
    end
  end
end
