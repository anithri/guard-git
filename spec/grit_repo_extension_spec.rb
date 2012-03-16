require "spec_helper"

describe GritRepoExtension do
  describe "#status_summary" do
    it "should have the method" do
      repo.respond_to?(:status_summary)
    end

    it "should report Clean! if no git status is clean" do
      repo.status_summary.should =~ /Clean!/
    end

    it "should report ~1 if 1 file has changed" do
      repo([1]).status_summary.should =~ /~1/
    end

    it "should report +1 if 1 file has been added" do
      repo([],[1]).status_summary.should =~ /\+1/
    end

    it "should report ~1 if 1 file has changed" do
      repo([],[],[1]).status_summary.should =~ /-1/
    end

    it "should report ~1 if 1 file has changed" do
      repo([],[],[],[1]).status_summary.should =~ /\?1/
    end

    it "should report ~1 +2 -3 ?4 if many files have changed" do
      repo([1],[1,2],[1,2,3],[1,2,3,4]).status_summary.should =~ /~1.+\+2.+-3.+\?4/
    end
  end
end

Status = Struct.new(*GritRepoExtension::SUMMARY_FORMAT.keys.sort)
Repo = Struct.new(:status)
def repo(changed = [], added = [], deleted = [], untracked = [])
  out = Repo.new(Status.new(added, changed, deleted, untracked))
  out.extend(GritRepoExtension)
  out
end