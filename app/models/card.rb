require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date
  attr_reader :end_date

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = 'createCard'
  STARTING_LANE = 'Resumes to be Screened'
  FINISHING_LANES = ['Success - Hired', 'Unsuccessful - Candidate Withdrew', 'Unsuccessful - Interview', 'Unsuccessful - Resume Screen']

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    binding.pry
    @start_date = check_create_type_start_date(board, id)
    if @start_date == 'Error'
      @end_date = 'Error'
    else
      @end_date = check_update_type_end_date(board, id, @list_name)
    end
  rescue
    @list_name = 'Error'
    @start_date = 'Error'
    @end_date = 'Error'
  end

  private
  def check_create_type_start_date(board, id)
    matching_actions = board.actions.find_all { |action| (action.type == TYPE_CREATE) && (action.data['list']['name'].present?) && (action.data['card']['id'] == id) }
    action = matching_actions.find { |action| (action.data['list']['name'].include?(STARTING_LANE)) }
    check_update_type_start_date(action, board, id)
  rescue
    return 'Error'
  end

  actions = matching_actions.find_all { |action| (action.type == TYPE_CREATE) && (action.data['list']['name'].include?(STARTING_LANE))}


  def check_update_type_start_date(selected_action, board, id)
    selected_action ||= board.actions.find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == id) }
    check_if_start_date_nil(selected_action)
  end

  def check_if_start_date_nil(selected_action)
    selected_action ? selected_action.date : nil
  end

  def check_update_type_end_date(board, id, list_name)
    if list_name.in?(FINISHING_LANES)
      action ||= board.actions.find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == id) }
    end
    check_if_end_date_nil(action)
  end

  def check_if_end_date_nil(selected_action)
    selected_action ? selected_action.date : nil
  end
end