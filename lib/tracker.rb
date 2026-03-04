class Tracker
  attr_reader :name, :sprints, :current_sprint

  def initialize(name)
    @name           = name
    @sprints        = { "backlog" => [] }  # sprint_name (String) => Array of BugReports
    @current_sprint = "backlog"
  end

  def create_sprint(name)
    raise ArgumentError, "Sprint name cannot be empty"     if name.to_s.strip.empty?
    raise ArgumentError, "Sprint '#{name}' already exists" if @sprints.key?(name)

    @sprints[name] = []
  end

  def switch(sprint_name)
    raise ArgumentError, "No such sprint '#{sprint_name}'" unless @sprints.key?(sprint_name)

    @current_sprint = sprint_name
  end

  # Returns reports in the sprint, newest first
  def history(sprint_name = current_sprint)
    raise ArgumentError, "No such sprint '#{sprint_name}'" unless @sprints.key?(sprint_name)

    @sprints[sprint_name].reverse
  end

  def file!(title:, reporter:, severity:)
    report = BugReport.new(
      title: title,
      reporter: reporter,
      severity: severity
    )
    @sprints[@current_sprint] << report
    report
  end
end
