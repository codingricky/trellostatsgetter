class TimeFilterService
  def self.filter_cards(days_ago)
    #needs something to bypass the filter when days_ago is nil/0.
    CardService.all.find_all { |card| card.start_date && card.start_date > (Date.today - days_ago.days) }
  end
end