class DownloadedCardService
  def self.save_cards(cards, location)
    DownloadedCard.destroy_all
    cards.collect do |card|
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
      local_card
    end
  end
end
