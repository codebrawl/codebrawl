module Codebrawl
  def self.config
    @config ||= YAML.load_file(
      File.expand_path("../../codebrawl.yml", __FILE__)
    )[Rails.env]
  end
end
