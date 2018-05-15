# frozen_string_literal: true

require 'singleton'

module SinatraOnRails
  module Routing
    class RouteHelper
      include ActiveSupport::Inflector
      include Singleton

      @@routes_module = Module.new

      class << self
        def define_helper(path, options)
          instance.define_helper(path, options)
        end

        def routes
          @@routes_module
        end
      end

      def define_helper(path, options)
        method_name = build_method_name(path, options)

        define_path_method(method_name, path)
        define_url_method(method_name)

        Sinatra.routes.routes << [path, options, method_name]
      end

      private

      def build_method_name(path, options)
        method_name = path[1..-1].split('/').reject { |path_str| path_str.start_with?(':') }.join('_')
        method_name = singularize(method_name) if %i[show update destroy].include?(options[:to][:action])

        return "new_#{singularize method_name[0..-5]}" if options[:to][:action] == :new
        return "edit_#{singularize method_name[0..-6]}" if options[:to][:action] == :edit
        method_name
      end

      def define_path_method(method_name, path)
        route_module = self.class.routes
        return if route_module.method_defined?("#{method_name}_path")

        route_module.send(:define_method, "#{method_name}_path") do |*args|
          return path if args.empty?

          query_params = args.extract_options!
          query_params.keys.inject(path) do |path_with_params, query_param|
            path_with_params.gsub(":#{query_param}", query_params[query_param].to_s)
          end
        end
      end

      def define_url_method(method_name)
        route_module = self.class.routes
        return if route_module.method_defined?("#{method_name}_url")

        route_module.send(:define_method, "#{method_name}_url") do |*args|
          options = args.extract_options!.dup
          host = options[:host] || Sinatra.secrets['url_options']['host']
          "#{host}#{send("#{method_name}_path", options)}"
        end
      end
    end
  end
end
