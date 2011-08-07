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

