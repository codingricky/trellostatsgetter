module SpecsHelper
  def self.create_one_card (list_name, action_date, action_date_finish, card_name)
    card_id = '1'
    card_list_id = '1'
    list_id = card_list_id
    action_type = 'createCard'
    action_card_id = card_id
    action_date = action_date
    action_type_finish = 'updateCard_finish'
    list = List.new(list_id, list_name)
    action = Action.new(action_type, action_card_id, action_date)
    action2 = Action.new(action_type_finish, action_card_id, action_date_finish)
    board = Board.new
    board.lists = [ list ]
    board.actions = [ action, action2 ]
    Card.new(board, card_name, card_id, card_list_id)
  end

  def self.create_a_card_multiple_lists (list_name)
    card_name = 'Bob'
    card_id = '1'
    card_list_id = '2'
    list_id = card_list_id
    dudlist_name = 'Dud List'
    dudlist_id = '1'
    dudlist2_name = 'Another dud List'
    dudlist2_id = '3'
    action_type = 'createCard'
    action_date = '1/1/1991'
    list = List.new(list_id, list_name)
    dudlist = List.new(dudlist_id, dudlist_name)
    dudlist2 = List.new(dudlist2_id, dudlist2_name)
    action = Action.new(action_type, card_id, action_date)
    board = Board.new
    board.lists = [ list, dudlist, dudlist2 ]
    board.actions = [ action ]
    Card.new(board, card_name, card_id, card_list_id)
  end

  def self.create_a_card_multiple_actions (action_date)
    list_name = 'The List'
    list_id = '2'
    action_type = 'updateCard'
    action_id = '2'
    oldaction_type = 'updateCard'
    oldaction_id = '2'
    oldaction_date = '1/1/1995'
    wrongaction_type = 'updateCard'
    wrongaction_id = '1'
    wrongaction_date = '1/1/1991'
    wrongaction2_type = 'createCard'
    wrongaction2_id = '1'
    wrongaction2_date = '1/1/1991'
    card_name = 'Bob'
    card_id = '2'
    card_list_id = '2'
    list = List.new(list_id, list_name)
    action = Action.new(action_type, action_id, action_date)
    oldaction = Action.new(oldaction_type, oldaction_id, oldaction_date)
    wrongaction = Action.new(wrongaction_type, wrongaction_id, wrongaction_date)
    wrongaction2 = Action.new(wrongaction2_type, wrongaction2_id, wrongaction2_date)
    board = Board.new
    board.lists = [ list ]
    board.actions = [ action, oldaction, wrongaction, wrongaction2 ]
    Card.new(board, card_name, card_id, card_list_id)
  end

  def self.populate_a_board(card_id, card_list_id)
    board = Board.new
    list_name = 'Sample List'
    action_type = 'createCard'
    action_date = nil
    list = List.new(card_list_id, list_name)
    lists = [ list ]
    board.lists = lists
    action = Action.new(action_type, card_id, action_date)
    board.actions = [ action ]
    board
  end

  def self.populate_a_board_with_stats(card_id, card_list_id, create_date, update_date)
    list_name = 'Success - Hired'
    create_type = 'createCard'
    update_type = 'updateCard_finish'
    board = Board.new
    list = List.new(card_list_id, list_name)
    lists = [ list ]
    board.lists = lists
    create = Action.new(create_type, card_id, create_date)
    update = Action.new(update_type, card_id, update_date)
    board.actions = [ create, update ]
    board
  end

  def self.create_empty_board
    board = Board.new
    board.cards = [ ]
    board.lists = [ ]
    board
  end

  def self.create_board_with_card(card_name, list_name, action_date)
    card_id = '1'
    card_list_id = '2'
    action_type = 'createCard'
    action_card_id = '1'
    list_id = '2'
    board = Board.new
    list = List.new(list_id, list_name)
    action = Action.new(action_type, action_card_id, action_date)
    board.lists = [ list ]
    board.actions = [ action ]
    card = Card.new(board, card_name, card_id, card_list_id)
    board.cards = [ card ]
    board
  end

  def self.create_board_with_bad_card(card_name, list_name, action_date, bad_card_name)
    card_id = '1'
    card_list_id = '2'
    action_type = 'createCard'
    action_card_id = '1'
    bad_action_type = 'movedCard'
    bad_action_card_id = '999999'
    list_id = '2'
    board = Board.new
    list = List.new(list_id, list_name)
    action = Action.new(action_type, action_card_id, action_date)
    bad_action = Action.new(bad_action_type, bad_action_card_id, action_date)
    board.lists = [ list ]
    board.actions = [ action, bad_action ]
    card = Card.new(board, card_name, card_id, card_list_id)
    bad_card = Card.new(board, bad_card_name, '999999', '999999')
    board.cards = [ card, bad_card ]
    board
  end
end