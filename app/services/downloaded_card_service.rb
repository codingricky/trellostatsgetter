class DownloadedCardService
  def self.save_cards(cards)
    cards.each do |card|
      card.save!
    end
  end
end