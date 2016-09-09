require 'trello'

TYPE_UPDATE = 'updateCard'
TYPE_CREATE = 'createCard'
STARTING_LANE = 'Resumes to be Screened'
FINISHING_LANES = ['Success - Hired', 'Unsuccessful - Candidate Withdrew', 'Unsuccessful - Interview', 'Unsuccessful - Resume Screen']

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date
  attr_reader :end_date
  #TODO use betterspec
  #TODO go through and refactor + make sure names are accurate
  #TODO test helper
  #TODO word columns nicer
  #TODO factorygirl for data

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @start_date = check_create_card_start_date(board, id)
    @end_date = check_update_card_end_date(board, id, @list_name)
  end

  private
  def check_create_card_start_date(board, id)
    action = board.actions.find { |action| (action.type == TYPE_CREATE) && (action.data['list']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == id) }
    check_update_card_start_date(action, board, id)
  end

  def check_update_card_start_date(selected_action, board, id)
    selected_action ||= board.actions.find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == id) }
    check_nil_start_date(selected_action)
  end

  def check_nil_start_date(selected_action)
    if selected_action then selected_action.date else nil end
  end

  def check_update_card_end_date(board, id, list_name)
    if list_name.in?(FINISHING_LANES)
      action ||= board.actions.find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == id) }
    end
    check_nil_end_date(action)
  end

  def check_nil_end_date(selected_action)
    if selected_action then selected_action.date else nil end
  end
end