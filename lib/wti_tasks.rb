require_relative 'wti_tasks/commands'

if defined? Rails::Railtie
  class WtiTasks::Load < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end
end