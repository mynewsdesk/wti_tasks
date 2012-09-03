require_relative 'wti_tasks/commands'
Dir["tasks/*.rake"].each { |ext| load ext } if defined?(Rake)
