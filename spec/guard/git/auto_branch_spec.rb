require "spec_helper"

describe Guard::GitExtension::AutoBranch do

  let(:repo) { Guard::Git.new()}
  describe "#computed_branch_name(orig_name)" do
    it "should use defaults to construct name" do
      repo.computed_branch_name("test").should == "auto/test"
    end

    it "should use options to construct name" do
      custom_repo = Guard::Git.new([],auto_branch_options: {prefix: "pre",suffix: "post", separator: "-"})
      custom_repo.computed_branch_name("test").should == "pre-test-post"
    end
  end

  describe "#auto_branch_name(orig_name)" do
    it "should use an explicit name over an assembled name" do
      custom_repo = Guard::Git.new([],auto_branch_options: {name: "foobar", prefix: "pre",suffix: "post",
          separator: "-"})
      custom_repo.auto_branch_name("test").should == "foobar"
    end
  end

  describe "#ok_to_branch?" do
    before(:each) do
      @output = ''
      Guard::UI.stub(:warning) { |msg| @output << msg + "\n" }
    end

    after(:each) do
      Guard::UI.unstub(:warning)
    end

    it "should return false if the new name is blank" do
      repo.instance_variable_set(:@auto_branch_name, "")
      repo.ok_to_branch?.should be_false
      @output.should match /No valid new branch name exists/
    end

    it "should return false if the new name is the same as the old name" do
      repo.instance_variable_set(:@auto_branch_name, "foobar")
      repo.instance_variable_set(:@orig_branch_name, "foobar")

      repo.ok_to_branch?.should be_false
      @output.should match /New branch name is same as original/
    end

    it "should return false if the branch_name already exists" do
      repo.instance_variable_set(:@auto_branch_name, "foobar")
      git_repo = repo.instance_variable_get(:@repo)
      git_repo.stub(:get_head).and_return(true)
      repo.ok_to_branch?.should be_false
      @output.should match /New branch name already exists/
    end

    it "should return true in all other cases" do
      repo.instance_variable_set(:@auto_branch_name, "foobar")
      repo.ok_to_branch?.should be_true
    end
  end

  describe "#branch_to(new_branch)" do
    let(:branch_repo) {Guard::Git.new([], repo_dir: setup_repo()) }

    it "should create a new branch" do
      new_branch_name = "test-branch"
      grit_repo = branch_repo.instance_variable_get(:@repo)
      grit_repo.get_head(new_branch_name).should be_nil
      branch_repo.branch_to(new_branch_name)
      grit_repo.get_head(new_branch_name).should_not be_nil
    end
  end

  describe "#start_auto_branch" do
    let(:branch_repo) {Guard::Git.new([], repo_dir: setup_repo()) }

    it "should create the auto generated branch name correctly" do
      grit_repo = branch_repo.instance_variable_get(:@repo)
      grit_repo.get_head("auto/master").should be_nil
      branch_repo.start_auto_branch
      grit_repo.get_head("auto/master").should_not be_nil
    end
  end
end

def setup_repo
  repo_dir = File.dirname(__FILE__) + "/../../support/repos"
  branching_repo = repo_dir + "/branching"
  if Dir.exist?(branching_repo)
    `cd #{branching_repo}; git checkout -q master; git branch -l | grep -v " master" | xargs git branch -d`
  else
    `cd #{repo_dir}; git init branching; cd branching; touch a b c d e; git add . ; git commit -m branches`
  end
  return branching_repo
end