require "spec_helper"

describe Guard::Git do

  describe "#initialize(watchers = [], options = {})" do
    it "should set some defaults" do
      options = subject.instance_variable_get(:@options)
      options.should have_key :repo_dir
    end

    it "should set a repo variable" do
      repo = subject.instance_variable_get(:@repo)
      repo.should be_a Grit::Repo
      repo.working_dir.should == Dir.pwd
    end

    it "should extend the repo variable with GitRepoExtension" do
      repo = subject.instance_variable_get(:@repo)
      repo.should respond_to(:status_summary)
    end

    it "should take options as a parameter" do
      repo = Guard::Git.new([],auto_branch_options: {test1: 123, another: "Hi"})
      options = repo.instance_variable_get(:@options)
      options[:auto_branch_options][:test1].should == 123
      options[:auto_branch_options][:another].should == "Hi"
    end
  end

  describe "#Git.add_to_default_options(hash)" do
    it "should add more options to the default hash" do
      Guard::Git.add_to_options({test1: true, another_test: "hi"})
      Guard::Git::DEFAULT_OPTIONS[:test1].should be_true
      Guard::Git::DEFAULT_OPTIONS[:another_test].should == "hi"
    end
  end

  describe "#Git.add_to_run_list(type, command, condition)" do
    it "should add to the RUN_LIST array" do
      Guard::Git.add_to_run_list(:start, :foo, :bar)
      Guard::Git::RUN_LISTS[:start].should include [:foo, :bar]
    end
  end


end