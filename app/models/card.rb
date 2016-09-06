require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date
  attr_reader :end_date

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @start_date = get_createCard_start_date(board, id)
    @end_date = get_updateCard_end_date(board, id, @list_name)
    if @start_date.present?
      @start_date = @start_date.to_datetime.strftime('%d %b %Y')
    end
    if @end_date.present?
      @end_date = @end_date.to_datetime.strftime('%d %b %Y')
    end
  end

  #TODO first implement new column for success (AND SHOW RICKY BEFORE PROGRESSING), then success + unsucc, then all (individual columns)
  def get_createCard_start_date(board, id)
    action = board.actions.find { |action| (action.type == 'createCard') && (action.data['list']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    get_updateCard_start_date(action, board, id)
  end

  def get_updateCard_start_date(selected_action, board, id)
    selected_action ||= board.actions.find { |action| (action.type == 'updateCard') && (action.data['listAfter']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    set_nil_start_date(selected_action)
  end

  def set_nil_start_date(selected_action)
    selected_action ||= OpenStruct.new(:date => nil)
    selected_action.date
  end

  def get_updateCard_end_date(board, id, list_name)
    if list_name.include?('Success' || 'Unsuccessful')
      action ||= board.actions.find { |action| (action.type == 'updateCard') && (action.data['listAfter']['name'].include?('Success' || 'Unsuccessful')) && (action.data['card']['id'] == id) }
    end
    set_nil_end_date(action)
  end

  def set_nil_end_date(selected_action)
    selected_action ||= OpenStruct.new(:date => nil)
    selected_action.date
  end
end