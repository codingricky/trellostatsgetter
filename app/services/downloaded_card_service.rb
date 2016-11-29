class DownloadedCardService
  def self.save_cards(cards)
    DownloadedCard.destroy_all
    cards.collect do |card|
      local_card = DownloadedCard.new(sanitized_name: card.name,
                         card_id: card.id,
                         list_id: card.list_id,
                         list_name: card.list_name,
                         start_date: card.start_date,
                         end_date: card.end_date,
                         url: card.url)
      local_card.save!
      local_card
    end
  end
end