class ActiveFilterService
  def self.filter_show_active_cards(cards)
    cards.find_all { |card| card.end_date.nil? }
  end

  def self.filter_show_inactive_cards(cards)
    cards.find_all { |card| card.end_date.present? }
  end
end