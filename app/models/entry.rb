class Entry
  include Mongoid::Document

  field :description, :type => String

  embedded_in :contest
end
