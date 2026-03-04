require "digest"

class BugReport
  attr_reader :id, :title, :reporter, :severity, :filed_at

  def initialize(title:, reporter:, severity:, filed_at: Time.now)
    raise ArgumentError, "Title cannot be empty"             if title.to_s.strip.empty?
    raise ArgumentError, "Reporter required"                 if reporter.nil?
    raise ArgumentError, "Severity must be between 1 and 4" unless (1..4).include?(severity)

    @title    = title
    @reporter = reporter
    @severity = severity
    @filed_at = filed_at
    @id       = compute_id  # 12 character string
  end

  private

  # private methods should not be tested directly
  def compute_id
    payload = [
      title,
      reporter.email,
      filed_at.utc
    ].join("\n")
    Digest::SHA1.hexdigest(payload)[0, 12]
  end
end
