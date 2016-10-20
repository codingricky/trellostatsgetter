require 'trello'

class ActionCache
  attr_reader :actions

  MAX_TRELLO_REQUEST_CARD_LIMIT = 1000

  def initialize(board)
    @actions = []
    last_id = nil
    last_page = false

    while !last_page
      current_page_of_actions = get_actions_from_board_before(board, last_id)
      current_page_of_actions.each {|action| @actions << action}
      last_id = current_page_of_actions.last.id
      last_page = is_last_page?(current_page_of_actions)
    end
  end

  def is_last_page?(actions)
    actions.count < MAX_TRELLO_REQUEST_CARD_LIMIT
  end

  def get_actions_from_board_before(board, last_id)
    Rails.logger.info("calling board.actions with last_id #{last_id}")
    if last_id
      board.actions(limit: MAX_TRELLO_REQUEST_CARD_LIMIT, before:last_id)
    else
      board.actions(limit: MAX_TRELLO_REQUEST_CARD_LIMIT)
    end
  end
end