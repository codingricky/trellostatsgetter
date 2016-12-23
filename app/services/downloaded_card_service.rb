class DownloadedCardService

  DEFAULT_NEW_DATE = DateTime.new(2001, 1, 1)

  def self.update_cards
    if LastUpdatedTime.current.nil?
      LastUpdatedTime.create!(time: (DEFAULT_NEW_DATE))
    end

    Board.all.each do |board|
      save_cards(TrelloService.return_new_cards(LastUpdatedTime.current.time, board.trello_id), board.location)
    end
    LastUpdatedTime.update_time
  end

  private
  def self.save_cards(cards, location)
    cards.each do |card|
      if DownloadedCard.exists?(card_id: card.card_id, location: location)
        existing_cards = DownloadedCard.where(card_id: card.card_id, location: location)
        current_card = existing_cards.first
        current_card.sanitized_name = card.name
        current_card.list_id = card.list_id
        current_card.list_name = card.list_name
        current_card.actions = card.actions
        current_card.attachments =  card.attachments
        current_card.card_json =  card.card_json
        if current_card.end_date.nil? && card.end_date.present?
          current_card.end_date = card.end_date
        end
        current_card.save!
      else
        new_card = DownloadedCard.new(sanitized_name: card.name,
                                      card_id: card.card_id,
                                      list_id: card.list_id,
                                      list_name: card.list_name,
                                      start_date: card.start_date,
                                      end_date: card.end_date,
                                      url: card.url,
                                      attachments: card.attachments,
                                      actions: card.actions,
                                      card_json: card.card_json,
                                      location: location)
        new_card.save!
      end
    end
  end
end

