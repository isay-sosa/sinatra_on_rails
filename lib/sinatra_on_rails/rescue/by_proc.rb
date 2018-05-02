# frozen_string_literal: true

module SinatraOnRails
  module Rescue
    class ByProc
      def initialize(proc)
        @proc = proc
      end

      def call(controller, exception)
        return controller.instance_exec(&@proc) if @proc.arity.zero?
        controller.instance_exec(exception, &@proc)
      end
    end
  end
end
