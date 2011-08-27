require 'active_support/string_inquirer'
require 'active_support/core_ext/module/delegation'

module State

  def state
    case
    when Time.now.utc >= closing_at then 'finished'
    when Time.now.utc >= voting_at then 'voting'
    when Time.now.utc >= starting_at then 'open'
    else
      'pending'
    end
  end

  def inquirable_state
    ActiveSupport::StringInquirer.new(state)
  end

  delegate \
    :pending?,
    :open?,
    :voting?,
    :finished?,
    :to => :inquirable_state

  def next_state_at
    case state
    when 'open' then voting_at
    when 'voting' then closing_at
    end
  end

end
