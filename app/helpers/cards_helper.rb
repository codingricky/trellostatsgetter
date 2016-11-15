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

  def self.show_colour_status(card)
    if card.end_date.present?
      return ''
    end
    if card.duration_in_days < 10
      return '#008000'
    end
    if (card.duration_in_days > 9) && (card.duration_in_days  < 20)
      return '#FFC200'
    end
    if card.duration_in_days > 19
      return '#FF0000'
    end
  end
end

