require 'guard'
require 'guard/guard'
require 'grit'
require 'grit_repo_extension'
require 'guard/git/auto_branch'
require 'guard/git/status'

module Guard
  class Git < Guard

    DEFAULT_OPTIONS = {
              repo_dir: Dir.pwd
    }

    RUN_LISTS = {}
    [:start, :stop, :reload, :run_all, :run_on_change, :run_on_deletion].each do |type|
      RUN_LISTS[type] = []
    end

    def self.add_to_options(new_hash)
      DEFAULT_OPTIONS.merge!(new_hash)
    end

    def self.add_to_run_list(type, command, condition)
      RUN_LISTS[type] << [command, condition]
    end

    include GitExtension::AutoBranch
    include GitExtension::Status

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
      @options = DEFAULT_OPTIONS.dup.update(options)
      @repo = ::Grit::Repo.new(@options[:repo_dir])
      @repo.extend(::GritRepoExtension)
    end

    def run_list(type)
      warn "run_list for #{type}"
      RUN_LISTS[type].each do |ary|
        (command, condition) = ary
        self.send(command) if self.send(condition)
      end
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      UI.info "Guard::Git is running, with grit #{Grit.version}"
      warn RUN_LISTS
      run_list(:start)
    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).# @raise [:task_has_failed] when stop has faileddeffailed
    def stop
      run_list(:stop)
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
      UI.info "Guard::Git is running, with grit #{Grit.version}"
      run_list(:reload)
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      run_list(:run_all)
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      run_list(:run_on_change)
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
      run_list(:run_on_deletion)
    end
  end
end
