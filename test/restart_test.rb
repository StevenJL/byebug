require_relative 'test_helper'

describe "Restart Command" do
  include TestDsl

  let(:initial_dir) { Pathname.new(__FILE__ + "/../..").realpath.to_s }
  let(:prog_script) do
    Pathname.new(fullpath('restart')).relative_path_from(Pathname.new(Byebug::INITIAL_DIR)).cleanpath.to_s
  end
  let(:rdebug_script) { 'rdebug-script' }

  def must_restart
    Byebug::RestartCommand.any_instance.unstub(:exec)
    Byebug::RestartCommand.any_instance.expects(:exec)
  end

  before do
    force_set_const(Byebug, "INITIAL_DIR", initial_dir)
    force_set_const(Byebug, "PROG_SCRIPT", prog_script)
    force_set_const(Byebug, "RDEBUG_SCRIPT", rdebug_script)
    Byebug::Command.settings[:argv] = ['argv']
    Byebug::RestartCommand.any_instance.stubs(:exec).with("#{rdebug_script} argv")
  end

  it "must be restarted with arguments" do
    Byebug::RestartCommand.any_instance.expects(:exec).with("#{rdebug_script} test/examples/restart.rb 1 2 3")
    enter 'restart 1 2 3'
    debug_file('restart')
  end

  it "must be restarted without arguments" do
    Byebug::RestartCommand.any_instance.expects(:exec).with("#{rdebug_script} argv")
    enter 'restart'
    debug_file('restart')
  end

  it "must specify arguments by 'set' command" do
    temporary_change_hash_value(Byebug::Command.settings, :argv, []) do
      Byebug::RestartCommand.any_instance.expects(:exec).with("#{rdebug_script}  1 2 3")
      enter 'set args 1 2 3', 'restart'
      debug_file('restart')
    end
  end

  describe "messaging" do
    before { enter 'restart' }

    describe "reexecing" do
      it "must restart" do
        must_restart
        debug_file('restart')
      end

      it "must show a message about reexecing" do
        debug_file('restart')
        check_output_includes "Re exec'ing:\n\t#{rdebug_script} argv"
      end
    end

    describe "no script is specified and don't use $0" do
      before do
        Byebug.send(:remove_const, "PROG_SCRIPT")
        force_set_const(Byebug, "DEFAULT_START_SETTINGS", init: false, post_mortem: false, tracing: nil)
      end

      it "must not restart" do
        must_restart.never
        debug_file('restart')
      end

      it "must show an error message" do
        debug_file('restart')
        check_output_includes "Don't know name of debugged program", interface.error_queue
      end
    end

    it "must use prog_script from $0 if PROG_SCRIPT is undefined" do
      $0 = 'prog-0'
      Byebug.send(:remove_const, "PROG_SCRIPT")
      force_set_const(Byebug, "DEFAULT_START_SETTINGS", init: true, post_mortem: false, tracing: nil)
      debug_file('restart')
      check_output_includes "Ruby program prog-0 doesn't exist", interface.error_queue
    end

    describe "no script at the specified path" do
      before { force_set_const(Byebug, "PROG_SCRIPT", 'blabla') }

      it "must not restart" do
        must_restart.never
        debug_file('restart')
      end

      it "must show an error message" do
        debug_file('restart')
        check_output_includes "Ruby program blabla doesn't exist", interface.error_queue
      end
    end

    describe "byebug runner script is not specified" do
      before { Byebug.send(:remove_const, "RDEBUG_SCRIPT") }

      it "must restart anyway" do
        must_restart
        debug_file('restart')
      end

      it "must show a warning message" do
        debug_file('restart')
        check_output_includes "Byebug was not called from the outset..."
      end

      it "must show a warning message when prog script is not executable" do
        debug_file('restart')
        check_output_includes "Ruby program #{prog_script} doesn't seem to be executable..."
        check_output_includes "We'll add a call to Ruby."
      end
    end

    describe "when can't change the dir to INITIAL_DIR" do
      before { force_set_const(Byebug, "INITIAL_DIR", "unexisted/path") }

      it "must restart anyway" do
        must_restart
        debug_file('restart')
      end

      it "must show an error message " do
        debug_file('restart')
        check_output_includes "Failed to change initial directory unexisted/path"
      end
    end
  end

  describe "Post Mortem" do
    it "must work in post-mortem mode" do
      skip("No post morten mode for now")
      #must_restart
      #enter 'cont', 'restart'
      #debug_file 'post_mortem'
    end
  end

end