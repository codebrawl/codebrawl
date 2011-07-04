require 'rspec/core/formatters/documentation_formatter'

# Assertive formatter for rspec
class BossFormatter < RSpec::Core::Formatters::DocumentationFormatter

  def passed_output(example)
    green("#{current_indentation}#{example.description} LIKE A BOSS!")
  end

  def dump_summary(duration, example_count, failure_count, pending_count)
    super(duration, example_count, failure_count, pending_count)
    # Don't print out profiled info if there are failures, it just clutters the output
    dump_profile if profile_examples? && failure_count == 0
    output.puts "\nFinished in #{format_seconds(duration)} seconds LIKE A BOSS!\n"
    output.puts colorise_summary(summary_line(example_count, failure_count, pending_count))
  end

end
