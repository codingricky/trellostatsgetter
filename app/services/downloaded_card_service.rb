class DownloadedCardService

  SYDNEY_BOARD_ID = '55ac308c4ae6522bbe90f501'
  SYDNEY_BOARD_NAME = 'Sydney - Software Engineers'

  MELB_BOARD_ID = '5302d67d65706eef448e5806'
  MELB_BOARD_NAME = 'Melbourne Recruitment Pipeline'


  def self.update_cards
    if LastUpdatedTime.first.nil?
      LastUpdatedTime.create!(time: (DateTime.civil_from_format :local, 2001))
    end
    save_cards(TrelloService.return_new_cards(LastUpdatedTime.first.time, SYDNEY_BOARD_ID), SYDNEY_BOARD_NAME)
    save_cards(TrelloService.return_new_cards(LastUpdatedTime.first.time, MELB_BOARD_ID), MELB_BOARD_NAME)
    last_run = LastUpdatedTime.first
    last_run.time = DateTime.current
    last_run.save!
  end

  private
  def self.save_cards(cards, location)
    cards.each do |card|
      if DownloadedCard.exists?(card_id: card.card_id, location: location)
        existing_cards = DownloadedCard.where(card_id: card.card_id, location: location)
        existing_cards.first.sanitized_name = card.name
        existing_cards.first.list_id = card.list_id
        existing_cards.first.list_name = card.list_name
        if existing_cards.first.end_date.nil? && card.end_date.present?
          existing_cards.first.end_date = card.end_date
        end
        existing_cards.first.save!
      else
        new_card = DownloadedCard.new(sanitized_name: card.name,
                                      card_id: card.card_id,
                                      list_id: card.list_id,
                                      list_name: card.list_name,
                                      start_date: card.start_date,
                                      end_date: card.end_date,
                                      url: card.url,
                                      attachments: card.attachments,
                                      location: location)
        new_card.save!
      end
    end
  end
end

