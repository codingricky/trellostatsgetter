module ViewHelper
  def self.calculate_average_duration(cards)
    return 0 unless cards.present?
    total_days = 0.00
    cards.each { |card| (total_days = total_days + card.duration_in_days) unless card.duration_in_days.nil? }
    return 0 unless (total_days.to_f > 0) && (cards.count > 0)
    total_days.to_f / cards.count
  end
end