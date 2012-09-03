require_relative '../lib/wti_tasks'

describe WtiTasks do
  let!(:wti) { WtiTasks.new }
  let(:filename) { "filename" }

  shared_examples_for "delegated class method" do
    let(:args) { [] }

    it "delegates to an instance of WtiTasks" do
      WtiTasks.should_receive(:new).any_number_of_times.and_return(wti)
      wti.should_receive(method).with(*args)
      WtiTasks.send(method, *args)
    end
  end

  describe ".find_projects" do
    let(:method) { :find_projects }
    it_should_behave_like "delegated class method"
  end

  describe ".pull" do
    let(:method) { :pull }
    it_should_behave_like "delegated class method"
  end

  describe ".push" do
    let(:method) { :push }
    it_should_behave_like "delegated class method"
  end


  describe "pull" do
    it "runs the pull command" do
      wti.should_receive(:run_command).with(:pull, filename)
      wti.pull filename
    end
  end


  describe "push" do
    it "runs the push command" do
      wti.should_receive(:run_command).with(:push, filename)
      wti.push filename
    end
  end


  describe "file_list" do
    it "finds a list of files matching .wti*" do
      Dir.should_receive(:glob).with('.wti*')
      wti.file_list
    end
  end


  describe "project_names" do
    let(:file_list) { ['.wti', '.wti-project1'] }

    it "gets the project name for each file" do
      file_list.each do |file|
        wti.should_receive(:project_name).with(file)
      end
      wti.project_names(file_list)
    end

    it "returns a hash with project names as key, file names as values" do
      expected = {
        default: '.wti',
        project1: '.wti-project1'
      }
      wti.project_names(['.wti', '.wti-project1']).should eq expected
    end
  end


  describe "project_name" do
    it "strips prefix from a file name" do
      wti.should_receive(:strip_prefix).with(filename).and_return('whatever')
      wti.project_name(filename)
    end

    it "renames the default project" do
      wti.should_receive(:rename_default).with(filename).and_return('whatever')
      wti.project_name(filename)
    end

    it "returns a symbol" do
      wti.project_name(filename).should eq :filename
    end
  end


  describe "strip_prefix" do
    it "strips off .wti- prefix from a file name" do
      wti.strip_prefix('.wti-project1').should eq 'project1'
    end
  end


  describe "rename_default" do
    it "renames .wti to default" do
      wti.rename_default('.wti').should eq 'default'
    end

    it "passes on other names" do
      wti.rename_default('.wti-project1').should eq '.wti-project1'
    end
  end


  describe "run_command" do
    before { wti.stub(:'`') } # Don't run commands in specs

    it "builds a wti push command" do
      wti.should_receive(:build_command).with(:pull, filename)
      wti.run_command(:pull, filename)
    end

    it "runs the command" do
      wti.stub(build_command: 'command')
      wti.should_receive(:'`').with('command')
      wti.run_command(:pull, filename)
    end
  end


  describe "build_command" do
    before { wti.stub(options: "") }

    it "constructs the specified wti command" do
      wti.build_command(:pull, filename).should match /wti pull/
      wti.build_command(:push, filename).should match /wti push/
    end

    it "tacks on a -c filename option" do
      wti.build_command(:pull, filename).should match /-c filename/
    end

    it "adds additional options" do
      wti.should_receive(:options).and_return('-f -l fr')
      wti.build_command(:pull, filename).should match /-f -l fr/
    end
  end


  describe "options" do
    context "when rake was called with -- --force --locale fr" do
      let(:argv) { ['wti:pull:default', '--force', '--locale', 'fr'] }

      it "builds a string of options for wti" do
        wti.options(argv).should eq " --force --locale fr"
      end
    end

    context "when there are no additional options for wti" do
      let(:argv) { ['wti:pull:default'] }

      it "returns an empty string" do
        wti.options(argv).should eq ""
      end
    end
  end
end
