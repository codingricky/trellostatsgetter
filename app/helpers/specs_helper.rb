module SpecsHelper

  def self.create_empty_board
    board = Board.new
    board.cards = [ ]
    board.lists = [ ]
    board
  end

  def self.create_board_with_card(card_name, list_name, action_date)
    card_id = '1'
    card_list_id = '2'
    list_id_to_name = {}
    list_id_to_name[card_list_id] = list_name
    action_type = 'createCard'
    action_card_id = '1'
    list_id = '2'
    board = Board.new
    list = List.new(list_id, list_name)
    action = Action.new(action_type, action_card_id, action_date)
    board.lists = [ list ]
    board.actions = [ action ]
    card = OpenStruct.new(name: card_name, id: card_id, list_id: card_list_id, list_name: list_name)
    board.cards = [ card ]
    board
  end

end