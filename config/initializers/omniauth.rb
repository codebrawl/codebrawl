Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    Codebrawl.config['github']['id'],
    Codebrawl.config['github']['secret'],
    {:scope => 'gist', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
