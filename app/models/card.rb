require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date

  def initialize(board, name, id, list_id)
    @name = name
    @id = id
    @list_id = list_id
    list = board.lists.find { |list| list.id == list_id }
    @list_name = list.name
    @start_date = get_start_date(board, id)
  end

  #TODO truncate date field
  #TODO first implement new column for success, then success + unsucc, then all (individual columns)
  def get_start_date(board, id)
    # Was the card created in the Resumes to be Screened lane? If so, use that date.
    action = board.actions.find { |action| (action.type == 'createCard') && (action.data['list']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    # If not; was the card moved into the Resumes to be Screened lane? If so, use the date of the latest time this occurred.
    action ||= board.actions.find { |action| (action.type == 'updateCard') && (action.data['listAfter']['name'].include?('Resumes to be Screened')) && (action.data['card']['id'] == id) }
    # If not; tell the user that the card had not been initialized properly, and return action.
    action ||= OpenStruct.new(:date => 'This card has never been placed in the Resumes to be Screened lane.')
    action.date
  end
end