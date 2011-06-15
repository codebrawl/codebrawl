Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    'e17efcf41c75f7aef25b',
    'fd74b7c6d05f546c162ef6c29e7f055515a50d53',
    {:scope => 'gist', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
