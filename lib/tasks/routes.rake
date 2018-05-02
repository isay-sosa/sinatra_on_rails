# frozen_string_literal: true

desc 'Print out all defined routes'
task :routes do
  puts Sinatra.routes.print
end
