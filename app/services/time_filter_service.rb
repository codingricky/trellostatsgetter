require 'trello'

class TimeFilterService
  def self.filter_cards(days_ago)
    cards = CardService.all
    if days_ago > 0
      cards_not_nil = cards.find_all{ |card| card.start_date.present? }
      filtered_cards = cards_not_nil.find_all{ |card| card.start_date > (Date.today - days_ago.to_i).to_time }
      return filtered_cards
    else
      return cards
    end
  end
end