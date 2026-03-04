# Bug Tracker Demo
#
# This is a simplified model of a bug tracking system.
# Real bug trackers are much more complex and integrate with code repositories,
# CI/CD pipelines, and project management tools.
#
# The demo shows two developers filing reports across
# two sprints and viewing the history of each.

require_relative "lib/developer"
require_relative "lib/bug_report"
require_relative "lib/tracker"

tracker = Tracker.new("SearchSphere")
miguel  = Developer.new("Miguel Perez", "miguel@searchsphere.io", "lead")
luis    = Developer.new("Luis Perez",   "luis@searchsphere.io",   "engineer")

tracker.file!(title: "Search results return duplicates for quoted queries",   reporter: miguel, severity: 2)
tracker.file!(title: "Autocomplete suggestions fail on non-ASCII characters", reporter: luis,   severity: 3)

tracker.create_sprint("sprint-1")
tracker.switch("sprint-1")
tracker.file!(title: "Index not updated after document deletion",             reporter: luis,   severity: 1)
tracker.file!(title: "Relevance ranking ignores page freshness signal",       reporter: miguel, severity: 2)

puts "Sprints: #{tracker.sprints.keys.join(', ')}"

puts "\nHistory (backlog):"
tracker.history("backlog").each { |r| puts " * #{r.id} [sev #{r.severity}] #{r.title} (#{r.reporter.email})" }

puts "\nHistory (sprint-1):"
tracker.history("sprint-1").each { |r| puts " * #{r.id} [sev #{r.severity}] #{r.title} (#{r.reporter.email})" }
