class ActiveFilterService
  def self.filter_show_active_cards(cards)
    cards.find_all { |card| card.is_active? }
  end

  def self.filter_show_inactive_cards(cards)
    cards.find_all { |card| !card.is_active? }
  end
end