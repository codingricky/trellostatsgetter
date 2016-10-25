class TimeFilterService
  def self.filter_cards(days_ago)
    CardService.all.find_all { |card| card.start_date && card.start_date > (Date.today - days_ago.days) }
  end
end