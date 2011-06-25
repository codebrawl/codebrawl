module Codebrawl
  def self.config
    @config ||= YAML.load_file(File.expand_path('../../codebrawl.yml', __FILE__))
  end
end
