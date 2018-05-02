# frozen_string_literal: true

module SinatraOnRails
  module Viewable
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
