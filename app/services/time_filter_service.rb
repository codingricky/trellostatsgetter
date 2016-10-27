class TimeFilterService
  def self.filter_cards(days_old)
      CardService.all.find_all { |card| card.start_date && card.start_date > (Date.today - days_old.days) }
  end
end