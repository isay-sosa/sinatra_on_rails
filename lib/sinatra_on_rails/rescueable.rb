# frozen_string_literal: true

require_relative 'rescue/by_method'
require_relative 'rescue/by_proc'

module SinatraOnRails
  module Rescueable
    def self.included(base)
      base.extend(ClassMethods)
    end

    def rescue_with_handler(exception)
      rescueable = self.class.exceptions[exception.class.to_s]
      return rescueable.call(self, exception) if rescueable
      raise exception
    end

    module ClassMethods
      def exceptions
        @exceptions ||= {}

        if superclass.respond_to?(:exceptions)
          superclass.exceptions.merge(@exceptions)
        else
          @exceptions
        end
      end

      def rescue_from(*args, &block)
        @exceptions ||= {}

        rescueable = if block_given?
                       Rescue::ByProc.new(block)
                     else
                       method_or_proc = args.pop
                       rescue_klass = method_or_proc.is_a?(Proc) ? Rescue::ByProc : Rescue::ByMethod
                       rescue_klass.new(method_or_proc)
                     end

        args.each { |exception| @exceptions[exception.to_s] = rescueable }
      end
    end
  end
end
