require 'trello'

class CardService

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']
  STARTING_LANE = 'Resumes to be Screened'
  FINISHING_LANES = ['Success - Hired', 'Unsuccessful - Candidate Withdrew', 'Unsuccessful - Interview', 'Unsuccessful - Resume Screen', 'Unsuccessful - Code Test', 'Candidate Withdrew', 'Hired!']

  def self.all
    Trello.configure do |config|
      config.developer_public_key = "27dbf126a87c20a0a1a6c9f81fcc2e98"
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
    member = find_member
    raise 'Member is invalid/not found.' unless member.present?

    Rails.logger.info("calling member.boards")
    board = member.boards.find { |board| (board.name == ENV['TRELLO_BOARD_NAME']) }
    raise 'Board name is invalid/not found.' unless board.present?

    list_of_actions = ActionService.get_actions(board)
    list_id_name = create_list_id_to_name(board)
    Rails.logger.info("calling board.cards")
    all_cards = board.cards.collect{|card| Card.new(id: card.id,
                                                    name: card.name,
                                                    list_id: card.list_id,
                                                    list_name: list_id_name[card.list_id],
                                                    start_date: find_start_date(card.id, list_of_actions),
                                                    end_date: find_end_date(card.id, list_id_name[card.list_id], list_of_actions))}
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
        action.data['list']['name'] == STARTING_LANE &&
        action.data['list']['name'].present? &&
        (action.data['card']['id'] == card_id)
  end

  def self.did_update_action_end_in_starting_lane?(card_id, action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == card_id)
  end

  def self.find_end_date(card_id, list_name, actions)
    if list_name.in?(FINISHING_LANES)
      selected_action = actions.find { |action| did_update_action_end_in_finishing_lane?(card_id, action) }
    end
    selected_action.try(:date)
  end

  def self.did_update_action_end_in_finishing_lane?(card_id, action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == card_id)
  end

  def self.find_member
    Rails.logger.info('calling Trello find')
    Trello::Member.find(ENV['TRELLO_MEMBER_ID'])
  end

  def self.create_list_id_to_name(board)
    lists = board.lists
    return nil if lists.nil?
    Hash[lists.map {|list| [list.id, list.name]}]
  end

end