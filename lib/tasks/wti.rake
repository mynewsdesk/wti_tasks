# encoding: utf-8
require_relative '../wti_tasks/commands'

namespace :wti do
  projects = WTI.find_projects

  namespace :pull do
    desc "Pull wti translations for all projects (.wti*)"
    task :all => projects.keys

    projects.each do |project, file|
      desc "Pull wti translations for #{project} project (#{file})"
      task project do
        puts WTI.pull(file)
      end
    end
  end

  namespace :push do
    desc "Push wti translations for all projects (.wti*)"
    task :all => projects.keys

    projects.each do |project, file|
      desc "Push wti translations for #{project} project (#{file})"
      task project do
        puts WTI.push(file)
      end
    end
  end

  desc "How to pass arguments to wti rake tasks"
  task :help do
    puts %{
    wti command options can be passed on to rake tasks by
    separating them from rake options with --.
    Example:

        rake wti:pull:default -- --locale es --force
    }
  end
end