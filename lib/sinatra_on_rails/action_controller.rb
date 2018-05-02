# frozen_string_literal: true

require_relative 'viewable'
require 'active_support/rescuable'

module SinatraOnRails
  class ActionController
    attr_reader :context

    extend Forwardable
    include ActiveSupport::Rescuable
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
      rescue_with_handler(ex) || raise
    end
  end
end
