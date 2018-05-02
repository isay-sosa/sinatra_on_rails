# frozen_string_literal: true

require_relative 'rescueable'
require_relative 'viewable'

module SinatraOnRails
  class ActionController
    attr_reader :context

    extend Forwardable
    include Rescueable
    include Viewable

    def_delegators :context, :params, :status, :redirect

    def initialize(context)
      @context = context

      # TODO: Delegate from UrlHelper module instead
      self.class.def_instance_delegators(:context, *context.methods.grep(/_path|_url/))
    end

    def call(action)
      public_send(action)
    rescue Exception => ex
      rescue_with_handler(ex)
    end
  end
end
