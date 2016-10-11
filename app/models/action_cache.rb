require 'trello'

class ActionCache
  attr_reader :actions

  def initialize(board)
    last_page = nil
    action_cache = Array.new
    action_cache << board.actions(limit:1000)
    last_id = action_cache.last.last.id
    while last_page.nil?
      current_page = board.actions(limit:1000, before:last_id)
      action_cache << current_page
      last_id = action_cache.last.last.id
      if current_page.count < 1000 then last_page = true end
    end
    puts 'Total amount of actions is '
    total = ((action_cache.count - 1) * 1000 + action_cache.last.count)
    puts total
    @actions = action_cache
  end
end