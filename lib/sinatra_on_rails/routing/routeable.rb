# frozen_string_literal: true

module SinatraOnRails
  module Routing
    module Routeable
      private

      def resources_path(resource_levels)
        resource_levels.inject('') do |parent_path, resource_route|
          "#{parent_path}/#{resource_route.parent_path}"
        end
      end
    end
  end
end
