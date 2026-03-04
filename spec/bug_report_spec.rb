require "digest"
require_relative "../lib/bug_report"
require_relative "../lib/developer"

RSpec.describe BugReport do
  let(:reporter) { Developer.new("Luis Perez", "luis@searchsphere.io", "engineer") }

  describe "#initialize" do
    it "creates a BugReport with title, reporter, severity, filed_at, and 12-char id" do
      fixed_time = Time.utc(2026, 3, 3, 12, 0, 0)

      report = BugReport.new(
        title: "Autocomplete fails on non-ASCII",
        reporter: reporter,
        severity: 3,
        filed_at: fixed_time
      )

      expect(report.title).to eq("Autocomplete fails on non-ASCII")
      expect(report.reporter).to eq(reporter)
      expect(report.severity).to eq(3)
      expect(report.filed_at).to eq(fixed_time)
      expect(report.id).to be_a(String)
      expect(report.id.length).to eq(12)
    end

    it "computes the expected SHA1-based 12-char id (deterministic with fixed filed_at)" do
      fixed_time = Time.utc(2026, 3, 3, 12, 0, 0)
      title = "Index not updated after deletion"

      report = BugReport.new(
        title: title,
        reporter: reporter,
        severity: 1,
        filed_at: fixed_time
      )

      payload = [title, reporter.email, fixed_time.utc].join("\n")
      expected_id = Digest::SHA1.hexdigest(payload)[0, 12]

      expect(report.id).to eq(expected_id)
    end

    it "rejects empty title" do
      expect {
        BugReport.new(title: "", reporter: reporter, severity: 2, filed_at: Time.utc(2026, 3, 3))
      }.to raise_error(ArgumentError, "Title cannot be empty")
    end

    it "rejects missing reporter" do
      expect {
        BugReport.new(title: "Crash", reporter: nil, severity: 2, filed_at: Time.utc(2026, 3, 3))
      }.to raise_error(ArgumentError, "Reporter required")
    end

    it "rejects severity below 1" do
      expect {
        BugReport.new(title: "Crash", reporter: reporter, severity: 0, filed_at: Time.utc(2026, 3, 3))
      }.to raise_error(ArgumentError, "Severity must be between 1 and 4")
    end

    it "rejects severity above 4" do
      expect {
        BugReport.new(title: "Crash", reporter: reporter, severity: 5, filed_at: Time.utc(2026, 3, 3))
      }.to raise_error(ArgumentError, "Severity must be between 1 and 4")
    end

    it "accepts boundary severities 1 and 4" do
      expect {
        BugReport.new(title: "Critical", reporter: reporter, severity: 1, filed_at: Time.utc(2026, 3, 3))
      }.not_to raise_error

      expect {
        BugReport.new(title: "Minor", reporter: reporter, severity: 4, filed_at: Time.utc(2026, 3, 3))
      }.not_to raise_error
    end
  end
end