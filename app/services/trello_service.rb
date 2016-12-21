require 'trello'

class TrelloService

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']

  def self.init_trello
    Trello.configure do |config|
      config.developer_public_key = "27dbf126a87c20a0a1a6c9f81fcc2e98"
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
  end

  def self.return_new_cards(time, board_id)
    init_trello
    difference_in_days = ((DateTime.now.to_date - time.to_date).to_i + 1)

    member = find_member
    raise 'Member is invalid/not found.' unless member.present?

    board = member.boards.find { |board| board.id == board_id }
    raise 'Board name is invalid/not found.' unless board.present?

    has_recently_edited_cards = get_trello_cards_with_changes(board_id, difference_in_days).any?
    return [] unless has_recently_edited_cards

    list_of_actions = ActionService.get_actions(board, difference_in_days)
    list_id_name_map = Hash[board.lists.map { |list| [list.id, list.name] }]

    new_cards = get_trello_cards_with_changes(board_id, difference_in_days).collect { |card| TrelloCard.new(card,
                                                                                                         list_of_actions,
                                                                                                         list_id_name_map[card.list_id]) }
    return new_cards
  end

  def self.get_trello_cards_with_changes(board_id, difference_in_days)
    # TODO investigate why first/second is required
    Trello::Action.search("board:#{board_id} edited:#{difference_in_days}", opts = {cards_limit: 1000}).first.second
  end

  def self.find_member
    Rails.logger.info('calling Trello find')
    Trello::Member.find(ENV['TRELLO_MEMBER_ID'])
  end

end