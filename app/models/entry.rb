require 'gist'

class GistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    gist = Gist.fetch(value)

    return record.errors[attribute] << "is not valid" unless gist.code == 200
    record.errors[attribute] << "is not yours" unless record.user.github_id == gist['user']['id']
  end
end

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gist_id, :type => String
  field :files, :type => Hash, :default => {}
  field :score, :type => Float, :default => 0.0

  validates :user, :gist_id, :presence => true
  validates :gist_id, :gist => true, :unless => :errors?

  embedded_in :contest
  embeds_many :votes
  embeds_many :comments
  belongs_to :user

  def votes_from?(user)
    votes.where(:user_id => user.id).any?
  end

  def errors?
    errors.any?
  end

  def calculate_score
    return 0.0 if votes.length.zero?
    votes.map(&:score).inject { |sum, el| sum + el }.to_f / votes.length
  end

  def score
    unless read_attribute(:score).nonzero?
      write_attribute(:score, calculate_score)
      save
    end

    read_attribute(:score)
  end

  def get_files_from_gist
    return {} unless gist_id
    response = Gist.fetch(gist_id)['files']
    result = {}
    response.each do |filename, file|
      file['content'] = nil if filename =~ /.*\.png$/
      result[filename.gsub('.', '*')] = file
    end
    result

  end

  def files
    if read_attribute(:files).empty?
      write_attribute(:files, get_files_from_gist)
      save
    end
    result = {}
    read_attribute(:files).each { |filename, file| result[filename.gsub('*', '.')] = file }
    result
  end

end
