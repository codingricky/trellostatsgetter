require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :raw_start_date
  attr_reader :raw_end_date #TODO remove raw
  #TODO ensure all of status col is deleted
  #TODO constants

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @raw_start_date = get_create_card_start_date(board, id)
    @raw_end_date = get_update_card_end_date(board, id, @list_name)
  end

  private
  def get_create_card_start_date(board, id)
    action = board.actions.find { |action| (action.type == 'createCard') && (action.data['list']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    get_update_card_start_date(action, board, id)
  end

  def get_update_card_end_date(board, id, list_name)
    if list_name.include?('uccess') #TODO sounds better if explicitly called
      action ||= board.actions.find { |action| (action.type == 'updateCard') && (action.data['listAfter'].present?) && (action.data['listAfter']['name'].include?('uccess')) && (action.data['card']['id'] == id) }
    end
    set_nil_end_date(action)
  end

  def get_update_card_start_date(selected_action, board, id)
    selected_action ||= board.actions.find { |action| (action.type == 'updateCard') && (action.data['listAfter'].present?) && (action.data['listAfter']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    set_nil_start_date(selected_action)
  end

  def set_nil_start_date(selected_action)
    if selected_action.present?
      selected_action.date
    else
      nil
    end
  end

  def set_nil_end_date(selected_action) #TODO bad name, setter should actually set something
    if selected_action.present?
      selected_action.date
    else
      nil
    end
  end #TODO ternary one line
end

#TODO make white background
#TODO word columns nicer