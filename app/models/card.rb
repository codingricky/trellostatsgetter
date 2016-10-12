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

  def initialize(board, name, id, list_id, action_cache)
    puts name
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @start_date = check_create_type_start_date(id, action_cache)
    if @start_date == 'Error'
      @end_date = 'Error'
    else
      @end_date = check_update_type_end_date(id, @list_name, action_cache)
    end
  rescue
    @list_name = 'Error'
    @start_date = 'Error'
    @end_date = 'Error'
  end

  private
  def check_create_type_start_date(id, action_cache)
    if action_cache.nil? then return nil end
    matching_actions = nil
    incrementing_value = 0
    while incrementing_value < action_cache.count
      matching_actions ||= action_cache[incrementing_value].find_all { |action| (action.type == TYPE_CREATE) && (action.data['list']['name'].present?) && (action.data['card']['id'] == id) }
      incrementing_value = incrementing_value + 1
    end
    selected_action = matching_actions.find { |action| (action.data['list']['name'].include?(STARTING_LANE)) }
    check_update_type_start_date(selected_action, id, action_cache)
  rescue
    return 'Error'
  end

  # USE THIS FUNCTION INSTEAD IF THE START DATE IS JUST FROM CREATION, NOT ENTERING RESUMES LANE.
  # def check_create_type_start_date(id, action_cache)
  #   matching_actions = action_cache.first.find { |action| (action.type == TYPE_CREATE) && (action.data['card']['id'] == id) }
  #   matching_actions ||= action_cache.second.find { |action| (action.type == TYPE_CREATE) && (action.data['card']['id'] == id) }
  #   matching_actions ||= action_cache.last.find { |action| (action.type == TYPE_CREATE) && (action.data['card']['id'] == id) }
  #   check_update_type_start_date(matching_actions, id, action_cache)
  # rescue
  #   return 'Error'
  # end

  def check_update_type_start_date(selected_action, id, action_cache)
    incrementing_value = 0
    while incrementing_value < action_cache.count
      selected_action ||= action_cache[incrementing_value].find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == id) }
      incrementing_value = incrementing_value + 1
    end
    check_if_start_date_nil(selected_action)
  end

  def check_if_start_date_nil(selected_action)
    selected_action ? selected_action.date : nil
  end

  def check_update_type_end_date(id, list_name, action_cache)
    if action_cache.nil? then return nil end
    if list_name.in?(FINISHING_LANES)
      selected_action = nil
      incrementing_value = 0
      while incrementing_value < action_cache.count
        selected_action ||= action_cache[incrementing_value].find { |action| (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == id) }
        incrementing_value = incrementing_value + 1
      end
    end
    check_if_end_date_nil(selected_action)
  end

  def check_if_end_date_nil(selected_action)
    selected_action ? selected_action.date : nil
  end
end