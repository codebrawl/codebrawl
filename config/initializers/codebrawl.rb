module Codebrawl
  class Config < Hashr
    define(
      :wufoo => { :api_key => '1111-1111-1111-1111' },
      :hoptoad => { :api_key => '11111111111111111111111111111111' },
      :github => {
        :id => 'e17efcf41c75f7aef25b',
        :secret => 'fd74b7c6d05f546c162ef6c29e7f055515a50d53'
      }
    )
  end

  def self.config
    settings = load_config_file[Rails.env] rescue {}
    @config ||= Config.new(settings)
  end

  private

    def self.load_config_file
      YAML.load_file(File.expand_path("../../codebrawl.yml", __FILE__))
    end
end
