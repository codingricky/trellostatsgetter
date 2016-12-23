class DownloadedCard < ActiveRecord::Base

  DEFAULT_SOURCE = "Direct"

  before_save :sanitize
  before_save :search_for_sources

  def is_active?
    self.end_date.nil?
  end

  def duration_in_days
    return nil if self.start_date.nil?

    start_date = self.start_date
    end_date = (self.end_date.nil? ? DateTime.now : self.end_date)
    (end_date.to_date - start_date.to_date).to_i
  end

  def sanitize
    self.sanitized_name = strip_money(self.sanitized_name)
    self.actions.each do |action|
      if action['data'] && action['data']['text']
        action['data']['text'] = strip_money(action['data']['text'])
      end
    end
  end

  def search_for_sources
    [self.sanitized_name, self.attachments.to_s, self.actions.to_s].each do |value|
      source = find_matching_source(value)
      if source
        self.source = source.name
        return
      end
    end
    self.source = DEFAULT_SOURCE
  end

  def find_matching_source(value)
    Source.all.find {|source| source.matches?(value)}
  end

  def self.search(location, days, active=nil)
    cards = DownloadedCard.where(location: location)
    # a lot of cards not being returned due to lack of start_date
    cards.find_all { |card| (card.duration_in_days && card.duration_in_days < days) && (active.nil? || card.is_active? == active) }
  end

  private

  def strip_money(value)
    value.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '') if value
  end
end