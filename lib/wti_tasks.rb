class WtiTasks
  def self.find_projects
    new.find_projects
  end

  def self.pull(*args)
    new.pull(*args)
  end

  def self.push(*args)
    new.push(*args)
  end

  def find_projects
    project_names file_list
  end

  def pull(filename)
    run_command(:pull, filename)
  end

  def push(filename)
    run_command(:push, filename)
  end

  def file_list
    Dir.glob '.wti*'
  end

  def project_names(files)
    files.inject({}) do |result, f|
      result[project_name(f)] = f
      result
    end
  end

  def project_name(file)
    file = strip_prefix(file)
    file = rename_default(file)
    file.to_sym
  end

  def strip_prefix(file)
    file.gsub(/\.wti-/, '')
  end

  def rename_default(file)
    file == '.wti' ? 'default' : file
  end

  def run_command(command, filename)
    wti_command = build_command command, filename
    `#{wti_command}`
  end

  def build_command(command, filename)
    "wti #{command} -c #{filename}" << options
  end

  def options(argv = ARGV)
    argv[0] = nil
    argv.join(' ')
  end
end
