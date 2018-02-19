# frozen_string_literal: true

require 'singleton'

module SinatraOnRails
  class ActionDispatcher
    include Singleton

    class << self
      def dispatch(app, controller:, action:)
        instance.dispatch(app, controller: controller, action: action)
      end
    end

    def dispatch(app, controller:, action:)
      dispatch_action_to_controller(app, controller, action)
    end

    private

    def controller_instance(app, controller)
      controller_klass(controller).new(app)
    end

    def controller_klass(controller)
      controller_name(controller.to_s).constantize
    end

    def controller_name(controller)
      "#{controller.camelcase}Controller"
    end

    def dispatch_action_to_controller(app, controller, action)
      controller_instance(app, controller).call(action)
    end
  end
end
