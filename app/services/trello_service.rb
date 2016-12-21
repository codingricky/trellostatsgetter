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
    new_cards = get_trello_cards_with_changes(board_id, difference_in_days).collect { |card| create_card(card,
                                                                                                         list_of_actions,
                                                                                                         list_id_name_map[card.list_id]) }
    return new_cards
  end

  def self.create_card(card, actions, list_name)
    new_card = OpenStruct.new
    new_card.card_id = card.id
    new_card.name = card.name
    new_card.list_id = card.list_id
    new_card.list_name = list_name
    new_card.start_date = find_start_date(card.id, actions)
    new_card.end_date = find_end_date(card.id, list_name, actions)
    new_card.url = card.url
    new_card.attachments = get_attachment_names(card.id, actions)
    new_card
  end

  def self.get_trello_cards_with_changes(board_id, difference_in_days)
    # TODO investigate why first/second is required
    Trello::Action.search("board:#{board_id} edited:#{difference_in_days}", opts = {cards_limit: 1000}).first.second
  end

  def self.find_start_date(card_id, actions)
    selected_action = actions.find { |action| is_create_action_in_starting_lane?(card_id, action) }
    selected_action ||= actions.find { |action| did_update_action_end_in_starting_lane?(card_id, action) }
    selected_action.try(:date)
  end

  def self.is_create_action_in_starting_lane?(card_id, action)
    (action.type.in? TYPE_CREATE) &&
        action.data['list']['name'].in?(ConfigService.starting_lanes) &&
        action.data['list']['name'].present? &&
        (action.data['card']['id'] == card_id)
  end

  def self.did_update_action_end_in_starting_lane?(card_id, action)
    (action.type == TYPE_UPDATE) &&
        (action.data['listAfter']) &&
        (action.data['listAfter']['name'].in?(ConfigService.starting_lanes)) &&
        (action.data['card']['id'] == card_id)
  end

  def self.find_end_date(card_id, list_name, actions)
    if list_name.in?(ConfigService.finishing_lanes)
      selected_action = actions.find { |action| did_update_action_end_in_finishing_lane?(card_id, action) }
    end
    selected_action.try(:date)
  end

  def self.did_update_action_end_in_finishing_lane?(card_id, action)
    (action.type == TYPE_UPDATE) &&
        (action.data['listAfter']) &&
        (action.data['listAfter']['name'].in?(ConfigService.finishing_lanes)) &&
        (action.data['card']['id'] == card_id)
  end

  def self.find_member
    Rails.logger.info('calling Trello find')
    Trello::Member.find(ENV['TRELLO_MEMBER_ID'])
  end

  def self.get_attachment_names(card_id, list_of_actions)
    attachment_actions = list_of_actions.find_all { |actions| actions.type == 'addAttachmentToCard' }
    attachments_for_this_card = attachment_actions.find_all { |actions| actions.data['card']['id'] == card_id }
    attachment_names = []
    attachments_for_this_card.each do |action|
      attachment_names << action.data['attachment']['name']
    end
    attachment_names
  end
end