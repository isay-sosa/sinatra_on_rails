# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

module SinatraOnRails
  class Application < Sinatra::Application
    set :root, Dir.pwd
    set :files, Dir["#{root}/app/**/*.rb"]
    set :initializers, Dir["#{root}/config/initializers/**/*.rb"]
    set :environments, Dir["#{root}/config/environments/**/*.rb"]
    set :views, File.join(root, 'app', 'views')
    set :views_engine, :erb

    class << self
      def inherited(base)
        super

        Sinatra.configure(base)
        require_environment_file
        include_helpers
      end

      def config(&block)
        Sinatra.application.instance_exec(&block)
      end

      private

      def collect_helpers
        files.each_with_object([]) do |file, helpers|
          next helpers unless file.include?('helpers')
          helpers << file.split('helpers/').last[0..-4].camelcase.constantize
          helpers
        end
      end

      def include_helpers
        helpers(*collect_helpers)
      end

      def require_environment_file
        environment_path = "#{root}/config/environments/#{Sinatra.env}.rb"
        require environment_path if File.exist?(environment_path)
      end
    end
  end
end
