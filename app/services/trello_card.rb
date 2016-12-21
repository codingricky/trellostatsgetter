class TrelloCard

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']

  attr_accessor :card_id, :name, :list_id, :list_name, :start_date, :end_date, :url, :attachments

  def initialize(card, actions, list_name)
    self.card_id = card.id
    self.name = card.name
    self.list_id = card.list_id
    self.list_name = list_name
    self.start_date = TrelloCard.find_start_date(card.id, actions)
    self.end_date = TrelloCard.find_end_date(card.id, list_name, actions)
    self.url = card.url
    self.attachments = TrelloCard.get_attachment_names(card.id, actions)
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