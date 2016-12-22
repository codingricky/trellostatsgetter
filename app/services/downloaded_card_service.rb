class DownloadedCardService

  SYDNEY_BOARD_ID = '55ac308c4ae6522bbe90f501'
  SYDNEY_BOARD_NAME = 'Sydney - Software Engineers'
  MELBOURNE_BOARD_ID = '5302d67d65706eef448e5806'
  MELBOURNE_BOARD_NAME = 'Melbourne Recruitment Pipeline'

  DEFAULT_NEW_DATE = DateTime.new(2001, 1, 1)

  def self.update_cards
    if LastUpdatedTime.current.nil?
      LastUpdatedTime.create!(time: (DEFAULT_NEW_DATE))
    end

    save_cards(TrelloService.return_new_cards(LastUpdatedTime.current.time, SYDNEY_BOARD_ID), SYDNEY_BOARD_NAME)
    save_cards(TrelloService.return_new_cards(LastUpdatedTime.current.time, MELBOURNE_BOARD_ID), MELBOURNE_BOARD_NAME)
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
                                      location: location)
        new_card.save!
      end
    end
  end
end

