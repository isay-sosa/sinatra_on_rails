# frozen_string_literal: true

require 'erb'
require_relative 'routes'
require 'yaml'

Encoding.default_internal = 'UTF-8'

module Sinatra
  class << self
    attr_accessor :logger
    attr_reader :application, :environment, :root, :routes, :secrets

    def configure(application)
      @application = application
      @environment = application.environment.to_s
      @root = application.root
      @routes = SinatraOnRails::Routes.new(application)
      setup_secrets
    end

    def method_missing(name, *_args, &_block)
      return name[0..-2] == environment if question_method?(name)
      super
    end

    def respond_to_missing?(name)
      question_method?(name)
    end

    private

    def question_method?(name)
      name[-1] == '?'
    end

    def setup_secrets
      secrets_path = File.join(root, 'config', 'secrets.yml')
      return unless File.exist?(secrets_path)

      secrets = YAML.safe_load(ERB.new(IO.read(secrets_path)).result)
      secrets_env = secrets[environment]

      return if secrets_env.nil? || secrets_env.empty?
      @secrets = secrets_env.each_with_object({}) do |(key, value), hash|
        hash[key] = value
        hash
      end
    end
  end
end
