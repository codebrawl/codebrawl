require 'rspec/core/formatters/base_formatter'
require 'simplecov'

# This formatter does nothing else but run SimpleCov. That means that if you run this formatter on
# its own, you won't get any output. It is advised to add your favorite formatter, like this, to see
# test failures and so on:
#
#   rspec spec -f SpecCoverage -fd
#
class SpecCoverage < ::RSpec::Core::Formatters::BaseFormatter

  def initialize(*)
    super
    add_default_filter
    load_simplecov_config
    start_simplecov
  end

  private

  # This is an RSpec filter, so we can safely assume that specs should be ignored
  def add_default_filter
    SimpleCov.add_filter '/spec/'
  end

  # Load a local .coverage file, to customize it yourself
  #
  # Example contents of this file:
  #
  #   SimpleCov.start do
  #     add_filter '/foo/'
  #   end
  #
  # Rails users might want to add at least something like:
  #
  #   SimpleCov.start 'rails'
  #
  def load_simplecov_config
    load config_file if config_exists?
  end

  def config_exists?
    File.exist?(config_file)
  end

  def config_file
    File.expand_path(".coverage", SimpleCov.root)
  end

  # If you didn't start SimpleCov in your .coverage file, start it now
  def start_simplecov
    SimpleCov.start unless SimpleCov.running
  end

end