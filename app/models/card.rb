require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :raw_start_date
  attr_reader :raw_end_date
  attr_reader :finished_cycle

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @raw_start_date = get_create_card_start_date(board, id)
    @raw_end_date = get_update_card_end_date(board, id, @list_name)
    @finished_cycle = set_if_done(@raw_start_date, @raw_end_date)
  end

  private
  def get_create_card_start_date(board, id)
    action = board.actions.find { |action| (action.type == 'createCard') && (action.data['list']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    get_update_card_start_date(action, board, id)
  end

  def get_update_card_end_date(board, id, list_name)
    if list_name.include?('uccess')
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

  def set_nil_end_date(selected_action)
    if selected_action.present?
      selected_action.date
    else
      nil
    end
  end

  def set_if_done(start_date, finish_date)
    if start_date.present? && finish_date.present?
      return true
    else
      return false
    end
  end
end