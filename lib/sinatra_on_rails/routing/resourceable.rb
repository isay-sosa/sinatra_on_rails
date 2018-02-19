# frozen_string_literal: true

require_relative 'route'
require_relative 'routeable'

module SinatraOnRails
  module Routing
    module Resourceable
      include Routeable

      def initialize(mapper, *resources, &block)
        @mapper = mapper
        @options = resources.extract_options!.dup
        @resource = resources.first
        @block = block
      end

      def draw_routes
        mapper.resource_levels << self

        resources_actions.each do |action|
          Route.new(mapper.app).draw(
            self.class::ACTIONS_WITH_HTTP_VERBS[action],
            args_from_resource(action)
          )
        end

        mapper.instance_exec(&block) if block
        mapper.resource_levels.pop
      end

      private

      attr_reader :mapper, :block, :options, :resource

      def args_from_resource(action)
        resource_options = {
          format: options[:format],
          to: {
            controller: controller,
            action: action.to_sym
          }
        }

        [build_path_from_resource(path, action), resource_options]
      end

      def base_path
        return @_base_path if defined?(@_base_path)

        resource_levels = mapper.resource_levels.dup
        resource_levels.pop

        @_base_path = resources_path(resource_levels)
      end

      def controller
        return resource.to_sym if mapper.module_levels.blank?

        modules = mapper.module_levels.map(&:module_name).join('/')
        "#{modules}/#{resource}"
      end

      def edit_value_path
        options[:path_names] ? options[:path_names][:edit] : :edit
      end

      def new_value_path
        options[:path_names] ? options[:path_names][:new] : :new
      end

      def path
        options[:path] || resource
      end

      def resources_actions
        options[:only] ||= self.class::ACTIONS
        options[:only] - (options[:except] || [])
      end
    end
  end
end
