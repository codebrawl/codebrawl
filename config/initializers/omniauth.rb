Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    Rails.env == 'production' ? 'a7e4f66ae5576162b1ed': 'e17efcf41c75f7aef25b',
    Rails.env == 'production' ? '407769aad0c9ddf74e530851fa9ee040e62029e2': 'fd74b7c6d05f546c162ef6c29e7f055515a50d53',
    {:scope => 'gist', :client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
end
