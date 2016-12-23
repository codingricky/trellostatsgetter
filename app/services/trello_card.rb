class TrelloCard

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = ['createCard', 'copyCard']

  attr_accessor :card_id, :name, :list_id, :list_name, :end_date, :url, :attachments, :actions, :card_json

  def initialize(card, actions, list_name)
    self.card_id = card.id
    self.name = card.name
    self.url = card.url
    self.list_id = card.list_id
    self.list_name = list_name
    self.end_date = TrelloCard.find_end_date(card.id, actions, list_name)
    self.actions = JSON.parse(card.actions.to_json)
    self.attachments = JSON.parse(card.attachments.to_json)
    self.card_json = JSON.parse(card.to_json)
  end

  def sanitize_money(value)
    value.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '') if value
  end

  def self.find_end_date(card_id, actions, list_name)
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

  def self.matching_actions(card_id, list_of_actions)
    list_of_actions.find_all { |actions| actions.data['card'] && actions.data['card']['id'] == card_id }
  end
end