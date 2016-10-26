class TimeFilterService
  def self.filter_cards(days_old)
    if days_old > 0
      CardService.all.find_all { |card| card.start_date && card.start_date > (Date.today - days_old.days) }
    else
      CardService.all
    end
  end
end