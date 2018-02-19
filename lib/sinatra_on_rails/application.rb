# frozen_string_literal: true

require 'active_support/inflector'
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
    set :logging, true

    helpers ActiveSupport::Inflector

    class << self
      def inherited(base)
        super

        Sinatra.configure(base)
        development_configure
        production_and_test_configure
        include_helpers
      end

      private

      def collect_helpers
        files.each_with_object([]) do |file, helpers|
          next helpers unless file.include?('helpers')
          helpers << file.split('helpers/').last[0..-4].camelcase.constantize
          helpers
        end
      end

      def development_configure
        configure(:development) do
          require_initializers
          require_and_watch_files
        end
      end

      def include_helpers
        helpers(*collect_helpers)
      end

      def production_and_test_configure
        configure(:production, :test) do
          require_initializers
          require_files
        end
      end

      def require_initializers
        initializers.sort.each { |file| require file }
      end

      def require_files
        files.sort.each { |file| require file }
      end

      def require_and_watch_files
        files.sort.each do |file|
          require file
          also_reload file
        end
      end
    end
  end
end
