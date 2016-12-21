require 'trello'

class TrelloService

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']

  def self.return_new_cards(time, board_id)
    difference_in_days = ((DateTime.now.to_date - time.to_date).to_i + 1)
    Trello.configure do |config|
      config.developer_public_key = "27dbf126a87c20a0a1a6c9f81fcc2e98"
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
    member = find_member
    raise 'Member is invalid/not found.' unless member.present?
    board = member.boards.find { |board| (board.id == board_id) }
    raise 'Board name is invalid/not found.' unless board.present?
    recently_edited_card_ids = get_trello_cards_with_changes(board_id, difference_in_days).collect { |card| OpenStruct.new(id: card.id) }
    return [] unless recently_edited_card_ids.any?
    list_of_actions = ActionService.get_actions(board, difference_in_days)
    list_id_name_map = Hash[board.lists.map { |list| [list.id, list.name] }]
    new_cards = get_trello_cards_with_changes(board_id, difference_in_days).collect { |card| OpenStruct.new(card_id: card.id,
                                                                                                            name: card.name,
                                                                                                            list_id: card.list_id,
                                                                                                            list_name: list_id_name_map[card.list_id],
                                                                                                            start_date: find_start_date(card.id, list_of_actions),
                                                                                                            end_date: find_end_date(card.id, list_id_name_map[card.list_id], list_of_actions),
                                                                                                            url: card.url,
                                                                                                            attachments: get_attachment_names(card.id, list_of_actions)) }
    return new_cards
  end

  def self.get_trello_cards_with_changes(location, difference_in_days)
    Trello::Action.search("board:#{location} edited:#{difference_in_days}", opts = {cards_limit: 1000}).first.second
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