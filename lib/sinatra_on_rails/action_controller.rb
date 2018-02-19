# frozen_string_literal: true

module SinatraOnRails
  class ActionController
    attr_reader :context

    extend Forwardable

    def_delegators :context, :params, :status, :redirect

    class << self
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
                       # Rescue::ByProc.new(block)
                       block
                     else
                       # method_or_proc = args.pop
                       # rescue_klass = method_or_proc.is_a?(Proc) ? Rescue::ByProc : Rescue::ByMethod
                       # rescue_klass.new(method_or_proc)
                       args.pop
                     end

        args.each { |exception| @exceptions[exception.to_s] = rescueable }
      end
    end

    rescue_from NoMethodError, :no_method!

    def initialize(context)
      @context = context
      self.class.def_instance_delegators(:context, *context.methods.grep(/_path/))
      self.class.def_instance_delegators(:context, *context.methods.grep(/_url/))
    end

    def call(action)
      public_send(action)
    rescue Exception => ex
      # TODO: Add rescue_from functionality
      # rescueable = self.class.exceptions[ex.class.to_s]
      # return rescueable.call(self, ex) if rescueable
      raise ex
    end

    protected

    def render(template_or_action, options = {})
      instance_variables_set

      template = if template_or_action.is_a?(Symbol)
                   :"#{views_folder}/#{template_or_action}.html"
                 else
                   template_or_action.to_sym
                 end
      render_engine_view template, options
    end

    private

    def instance_variables_set
      instance_variables.each do |instance_variable|
        next if instance_variable == :@context
        context.instance_variable_set(instance_variable, instance_variable_get(instance_variable))
      end
    end

    def render_engine_view(*args)
      context.send(Sinatra.application.views_engine, *args)
    end

    def views_folder
      self.class.to_s[0..-11].underscore
    end
  end
end
