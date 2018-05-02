# frozen_string_literal: true

module SinatraOnRails
  module Rescue
    class ByMethod
      def initialize(method_name)
        @method_name = method_name
      end

      def call(controller, exception)
        method = controller.method(@method_name)
        return method.call if method.arity.zero?
        method.call(exception)
      end
    end
  end
end
