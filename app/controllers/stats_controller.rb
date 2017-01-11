class StatsController < ApplicationController

  def index
    @days = params[:days] || 365
    @stats = []
    Board.all.each do |board|
      sources = Source.all.to_a
      sources << OpenStruct.new(name: DownloadedCard::DEFAULT_SOURCE)
      sources.each do |source|
        cards = DownloadedCard.where(source: source.name, location: board.location)
        cards = cards.find_all { |card| card.younger_than(@days)}
        no_of_hired = cards.to_a.count{|card| card.is_hired?}
        no_of_non_hired = cards.size - no_of_hired
        @stats << OpenStruct.new(location: board.location,
                                 source: source.name,
                                 no_of_hired: no_of_hired,
                                 no_of_non_hired: no_of_non_hired,
                                 total: cards.size)
      end
    end
  end

end