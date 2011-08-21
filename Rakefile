#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Codebrawl::Application.load_tasks

namespace :codebrawl do
  task :status => :environment do

    Contest.all.reject { |contest| contest.finished? }.each do |contest|
      puts table(
        contest.name,
        [
          'Entries:',
          *contest.entries.map do |e|
            "  #{{:login => e.user.login, :gist_id => e.gist_id}.inspect}"
          end
        ]
      )
    end

  end

  task :update_contributors => :environment do

    uri = URI.parse('https://api.github.com/repos/codebrawl/codebrawl/contributors')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    contributors = JSON.parse response.body

    contributors.each do |contributor|
      if user = User.first(:conditions => {:login => contributor['login']})
        user.update_attribute('contributions', contributor['contributions'])
      end
    end

  end
end

def table(title, content)
  output = line
  output += content title
  output += line
  content.each { |text| output += content text }
  output += line
  output += "\n"
end

def line
  "+#{'-' * 78}+\n"
end

def content(text)
  "| #{text}#{' ' * (77 - text.length)}|\n"
end

