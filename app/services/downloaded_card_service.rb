class DownloadedCardService
  def self.download_cards
    DownloadedCard.destroy_all
    save_cards(TrelloService.all('Sydney - Software Engineers'), 'Sydney - Software Engineers')
    save_cards(TrelloService.all('Melbourne Recruitment Pipeline'), 'Melbourne Recruitment Pipeline')
  end

  private
  def self.save_cards(cards, location)
    cards.each do |card|
      local_card = DownloadedCard.new(sanitized_name: card.sanitized_name,
                                      card_id: card.card_id,
                                      list_id: card.list_id,
                                      list_name: card.list_name,
                                      start_date: card.start_date,
                                      end_date: card.end_date,
                                      url: card.url,
                                      attachments: card.attachments,
                                      location: location)
      local_card.save!
    end
  end
end
