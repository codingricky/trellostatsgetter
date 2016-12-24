class StatsController < ApplicationController
  def index
    @stats = []
    Board.all.each do |board|
      Source.all.each do |source|
        cards = DownloadedCard.where(source: source.name, location: board.location)
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