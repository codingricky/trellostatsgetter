require 'trello'

class ActionCache
  attr_reader :actions

  def initialize(board)
    last_page = nil
    action_cache = Array.new
    action_cache << get_actions_from_board(board)
    last_id = action_cache.last.last.id
    if get_actions_from_board(board).count < 1000 then last_page = true end
    while last_page.nil?
      current_page = get_actions_from_board_before(board, last_id)
      action_cache << current_page
      last_id = action_cache.last.last.id
      if current_page.count < 1000 then last_page = true end
    end
    @actions = action_cache
  end

  def get_actions_from_board(board)
    Rails.logger.info("calling board.actions ")
    board.actions(limit:1000)
  end

  def get_actions_from_board_before(board, last_id)
    Rails.logger.info("calling board.actions with last_id #{last_id}")
    board.actions(limit:1000, before:last_id)
  end
end