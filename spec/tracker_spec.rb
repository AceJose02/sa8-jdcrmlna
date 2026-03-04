require_relative "../lib/tracker"
require_relative "../lib/developer"
require_relative "../lib/bug_report"

RSpec.describe Tracker do
    let(:tracker) { Tracker.new("SearchSphere") }
    let(:matthew) { Developer.new("Matthew Smith", "matthew.smith@proton.me", "lead") }
    let(:luis) { Developer.new("Luis Perez", "luis@searchsphere.io", "engineer") }

  describe "#initialize" do
    it "starts with backlog sprint and sets current_sprint to backlog" do
      expect(tracker.name).to eq("SearchSphere")
      expect(tracker.sprints.keys).to contain_exactly("backlog")
      expect(tracker.sprints["backlog"]).to eq([])
      expect(tracker.current_sprint).to eq("backlog")
    end
  end

  describe "#create_sprint" do
    it "creates a new empty sprint" do
      tracker.create_sprint("sprint-1")
      expect(tracker.sprints.keys).to include("sprint-1")
      expect(tracker.sprints["sprint-1"]).to eq([])
    end

    it "rejects empty sprint name" do
      expect { tracker.create_sprint("") }
        .to raise_error(ArgumentError, "Sprint name cannot be empty")
    end

    it "rejects duplicate sprint name" do
      tracker.create_sprint("sprint-1")
      expect { tracker.create_sprint("sprint-1") }
        .to raise_error(ArgumentError, "Sprint 'sprint-1' already exists")
    end
  end

  describe "#switch" do
    it "switches current sprint when sprint exists" do
      tracker.create_sprint("sprint-1")
      tracker.switch("sprint-1")
      expect(tracker.current_sprint).to eq("sprint-1")
    end

    it "rejects switching to a sprint that does not exist" do
      expect { tracker.switch("nope") }
        .to raise_error(ArgumentError, "No such sprint 'nope'")
    end
  end

  describe "#file!" do
    it "files a report into the current sprint and returns the BugReport" do
      report = tracker.file!(title: "Dup results", reporter: matthew, severity: 2)

      expect(report).to be_a(BugReport)
      expect(report.title).to eq("Dup results")
      expect(report.reporter).to eq(matthew)
      expect(report.severity).to eq(2)

      expect(tracker.sprints["backlog"]).to include(report)
    end

    it "files into whichever sprint is currently selected" do
      tracker.create_sprint("sprint-1")
      tracker.switch("sprint-1")

      r = tracker.file!(title: "Index stale", reporter: luis, severity: 1)

      expect(tracker.sprints["sprint-1"]).to include(r)
      expect(tracker.sprints["backlog"]).to be_empty
    end
  end

  describe "#history" do
    it "returns newest-first for the default (current) sprint" do
      r1 = tracker.file!(title: "First", reporter: matthew, severity: 2)
      r2 = tracker.file!(title: "Second", reporter: luis, severity: 3)

      expect(tracker.history).to eq([r2, r1])
    end

    it "returns newest-first for a specific sprint name" do
      tracker.file!(title: "B1", reporter: matthew, severity: 2)

      tracker.create_sprint("sprint-1")
      tracker.switch("sprint-1")
      s1 = tracker.file!(title: "S1", reporter: luis, severity: 1)
      s2 = tracker.file!(title: "S2", reporter: matthew, severity: 2)

      expect(tracker.history("sprint-1")).to eq([s2, s1])
    end

    it "rejects history for a sprint that does not exist" do
      expect { tracker.history("missing") }
        .to raise_error(ArgumentError, "No such sprint 'missing'")
    end
  end
end