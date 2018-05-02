# frozen_string_literal: true

require 'active_support/inflector'

module SinatraOnRails
  module Routing
    class RouteHelper
      include ActiveSupport::Inflector

      def initialize(app)
        @app = app
      end

      def define_helper(path, options)
        method_name = build_method_name(path, options)

        module_instance = Module.new do
          define_method("#{method_name}_path") do |*args|
            raise "#{Regexp.last_match(1)} argument was not passed in" if args.empty? && path =~ /:(\w*)?/
            return path if args.empty?

            query_params = args.extract_options!
            query_params.keys.inject(path) do |path_with_params, query_param|
              path_with_params.gsub(":#{query_param}", query_params[query_param].to_s)
            end
          end

          define_method("#{method_name}_url") do |*args|
            options = args.extract_options!.dup
            "#{options[:host] || Sinatra.secrets['url_options']['host']}#{send("#{method_name}_path", options)}"
          end
        end

        Sinatra.routes.routes << [path, options, method_name]
        app.helpers module_instance
      end

      private

      attr_reader :app

      def build_method_name(path, options)
        method_name = path[1..-1].split('/').reject { |path_str| path_str.start_with?(':') }.join('_')
        method_name = singularize(method_name) if %i[show update destroy].include?(options[:to][:action])

        return "new_#{singularize method_name[0..-5]}" if options[:to][:action] == :new
        return "edit_#{singularize method_name[0..-6]}" if options[:to][:action] == :edit
        method_name
      end
    end
  end
end
