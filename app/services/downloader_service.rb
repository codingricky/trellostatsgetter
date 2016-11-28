require 'trello'

class DownloaderService

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']

  def self.all(location)
    Trello.configure do |config|
      config.developer_public_key = "27dbf126a87c20a0a1a6c9f81fcc2e98"
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
    member = find_member
    raise 'Member is invalid/not found.' unless member.present?

    Rails.logger.info("calling member.boards")
    board = member.boards.find { |board| (board.name == location) }
    raise 'Board name is invalid/not found.' unless board.present?
    list_of_actions = ActionService.get_actions(board)
    list_id_name = Hash[board.lists.map {|list| [list.id, list.name]}]
    Rails.logger.info("calling board.cards")
    all_cards = board.cards.collect{|card| DownloadedCard.new(sanitized_name: sanitize_name(card.name),
                                                              card_id: card.id,
                                                              list_id: card.list_id,
                                                              list_name: list_id_name[card.list_id],
                                                              start_date: find_start_date(card.id, list_of_actions),
                                                              end_date: find_end_date(card.id, list_id_name[card.list_id], list_of_actions),
                                                              url: card.url ) }
    Rails.logger.info("calling all_cards.find_all")

    return all_cards
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
    (action.type == TYPE_UPDATE)  &&
        (action.data['listAfter']) &&
        (action.data['listAfter']['name'].in?(ConfigService.finishing_lanes)) &&
        (action.data['card']['id'] == card_id)
  end

  def self.find_member
    Rails.logger.info('calling Trello find')
    Trello::Member.find(ENV['TRELLO_MEMBER_ID'])
  end

  def self.sanitize_name(name)
    name.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '')
  end
end