class GistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    gist = Gist.fetch(value)

    return record.errors[attribute] << "is not valid" unless gist.code == 200
    record.errors[attribute] << "is not yours" unless record.user.github_id == gist['user']['id']
  end
end

class Entry
  include Mongoid::Document

  field :gist_id, :type => String
  field :files, :type => Hash, :default => {}
  field :score, :type => Float, :default => 0.0

  validates :user, :gist_id, :presence => true
  validates :gist_id, :gist => true, :unless => :errors?

  embedded_in :contest
  embeds_many :votes
  embeds_many :comments
  belongs_to :user

  def errors?
    errors.any?
  end

  def calculate_scrore
    return 0.0 if votes.length.zero?
    votes.map(&:score).inject { |sum, el| sum + el }.to_f / votes.length
  end

  def score
    write_attribute(:score, calculate_scrore) unless read_attribute(:score).nonzero?
    read_attribute(:score)
  end

  def get_files_from_gist
    return {} unless gist_id
    Gist.fetch(gist_id)['files']
  end

  def files
    write_attribute(:files, get_files_from_gist) if read_attribute(:files).empty?
    read_attribute(:files)
  end

end
