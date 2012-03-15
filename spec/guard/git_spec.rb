require "spec_helper"

describe Guard::Git do

  describe "#initialize(watchers = [], options = {})" do
    it "should set some defaults" do
      options = subject.instance_variable_get(:@options)
      options.should have(5).keys
      options.keys.should =~ [:auto_add, :auto_commit, :auto_rm, :status, :repo_dir]
    end

    it "should set a repo variable" do
      repo = subject.instance_variable_get(:@repo)
      repo.should be_a Grit::Repo
      repo.working_dir.should == Dir.pwd
      warn @prepo.status.pretty
    end
  end

end