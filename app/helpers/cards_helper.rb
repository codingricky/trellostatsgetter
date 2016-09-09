include ActionView::Helpers::DateHelper

module CardsHelper
  def self.show_start_date(card)
    if card.start_date
      card.start_date.to_datetime.strftime('%d %b %Y')
    else 'This card has never been placed in the Resumes to be Screened lane.'
    end
  end

  def self.show_end_date(card)
    if card.end_date
      card.end_date.to_datetime.strftime('%d %b %Y')
    else 'This card is not placed in an end lane.'
    end
  end

  def self.show_difference_in_time(card)
    if card.start_date && card.end_date
      duration = (distance_of_time_in_words card.end_date, card.start_date)
    end
    if card.start_date && duration.nil?
      duration = (distance_of_time_in_words Time.now, card.start_date) + '*'
    end
    if duration.nil?
      duration = 'This card duration cannot be calculated as it was not set up properly.'
    end
    duration
  end
end

