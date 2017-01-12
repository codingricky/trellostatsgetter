class StatsController < ApplicationController

  def index
    @days = params[:days] || 365
    @stats = []
    @cycle_time = []
    Board.all.each do |board|
      sources = Source.all.to_a
      sources << OpenStruct.new(name: DownloadedCard::DEFAULT_SOURCE)
      sources.each do |source|
        cards = DownloadedCard.where(source: source.name, location: board.location)
        cards = cards.find_all { |card| card.younger_than(@days) }
        no_of_hired = cards.to_a.count { |card| card.is_hired? }
        no_of_non_hired = cards.size - no_of_hired
        @stats << OpenStruct.new(location: board.location,
                                 source: source.name,
                                 no_of_hired: no_of_hired,
                                 no_of_non_hired: no_of_non_hired,
                                 total: cards.size)
      end

      cards_younger_than_days = DownloadedCard.where(location: board.location).to_a.find_all { |card| card.younger_than(@days) && card.finished? }
      cycle_time = cards_younger_than_days.collect { |element| element.cycle_time }
      @cycle_time << OpenStruct.new(location: board.location,
                                    cycle_time: median(cycle_time),
                                    count: cycle_time.size)
    end
  end

  def median(array, already_sorted=false)
    return nil if array.empty?
    array = array.sort unless already_sorted
    m_pos = array.size / 2
    array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
  end

  def mean(array)
    sum = array.inject(0) { |sum, x| sum += x }
    sum/ array.size.to_f
  end

end