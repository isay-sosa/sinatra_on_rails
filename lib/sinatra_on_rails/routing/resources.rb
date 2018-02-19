# frozen_string_literal: true

require 'active_support/inflector'
require_relative 'resourceable'

module SinatraOnRails
  module Routing
    class Resources
      include Resourceable
      include ActiveSupport::Inflector

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

      def parent_path
        "#{path}/:#{singularize(resource)}_id"
      end

      private

      def build_base_path(base_path, resource)
        "#{base_path}/#{resource.values.first}/:#{singularize(resource.keys.first)}_id"
      end

      def build_path_from_resource(resource, action)
        return "#{base_path}/#{resource}" if %i[create index].include?(action)
        return "#{base_path}/#{resource}/#{new_value_path}" if action == :new
        return "#{base_path}/#{resource}/:id/#{edit_value_path}" if action == :edit
        "#{base_path}/#{resource}/:id"
      end
    end
  end
end
