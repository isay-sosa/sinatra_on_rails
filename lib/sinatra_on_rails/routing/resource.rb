# frozen_string_literal: true

require_relative 'resourceable'

module SinatraOnRails
  module Routing
    class Resource
      include Resourceable

      ACTIONS = %i[create update new edit destroy show].freeze
      ACTIONS_WITH_HTTP_VERBS = {
        create: :post,
        destroy: :delete,
        edit: :get,
        new: :get,
        show: :get,
        update: :put
      }.freeze

      def parent_path
        "#{path}/#{resource}"
      end

      private

      def build_base_path(base_path, resource)
        "#{base_path}/#{resource.values.first}"
      end

      def build_path_from_resource(resource, action)
        return "#{base_path}/#{resource}" if action == :create
        return "#{base_path}/#{resource}/#{new_value_path}" if action == :new
        return "#{base_path}/#{resource}/#{edit_value_path}" if action == :edit
        "#{base_path}/#{resource}"
      end
    end
  end
end
