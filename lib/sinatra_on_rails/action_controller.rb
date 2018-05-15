# frozen_string_literal: true

require_relative 'viewable'
require 'active_support/rescuable'

module SinatraOnRails
  class ActionController
    attr_reader :context

    extend Forwardable
    include ActiveSupport::Rescuable
    include Viewable
    include Routing::RouteHelper.routes

    def_delegators :context, :params, :status, :redirect

    alias redirect_to redirect

    def initialize(context)
      @context = context
    end

    def call(action)
      public_send(action)
    rescue Exception => ex
      rescue_with_handler(ex) || raise
    end
  end
end
