Bundler.require(:default, :test)
#Dir.glob('app/models/*.rb').each { |file| require File.expand_path(file) }
#Dir.glob('spec/fabricators/*_fabricator.rb').each { |file| require File.expand_path(file) }

require File.expand_path("../../../config/environment", __FILE__)

