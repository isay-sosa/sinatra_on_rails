# frozen_string_literal: true

module SinatraOnRails
  module Routing
    class Namespace
      attr_reader :module_name, :parent_path

      def initialize(mapper, namespace, &block)
        @mapper = mapper
        @module_name = namespace
        @parent_path = namespace
        @block = block
      end

      def draw_routes
        mapper.module_levels << self
        mapper.resource_levels << self

        mapper.instance_exec(&block) if block

        mapper.module_levels.pop
        mapper.resource_levels.pop
      end

      private

      attr_reader :mapper, :block
    end
  end
end
