class TimeFilterService
  def self.filter_cards(days_old, location, show_only)
    cards = CardService.all(location).find_all { |card| card.start_date && card.start_date > (Date.today - days_old.days) }

    if show_only != 'all_cards' then
      show_only == 'active_cards' ? ActiveFilterService.filter_show_active_cards(cards) : ActiveFilterService.filter_show_inactive_cards(cards)
    else
      cards
    end
  end

end