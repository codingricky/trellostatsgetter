class TrelloCard

  attr_accessor :card_id, :name, :list_id, :list_name, :end_date, :url, :attachments, :actions, :card_json

  def initialize(card, list_name)
    self.card_id = card.id
    self.name = card.name
    self.url = card.url
    self.list_id = card.list_id
    self.list_name = list_name
    self.actions = JSON.parse(card.actions.to_json)
    self.attachments = JSON.parse(card.attachments.to_json)
    self.card_json = JSON.parse(card.to_json)
  end

end