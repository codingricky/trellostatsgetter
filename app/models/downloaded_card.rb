class DownloadedCard < ActiveRecord::Base
  before_save :sanitize_name
  before_save :search_for_sources

  def duration_in_days
    return nil if self.start_date.nil?

    start_date = self.start_date
    end_date = (self.end_date.nil? ? DateTime.now : self.end_date)
    (end_date.to_date - start_date.to_date).to_i
  end

  def sanitize_name
    self.sanitized_name = self.sanitized_name.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '')
  end

  def find_matching_source(name)
    ConfigService.source_names.find {|source_name| name.downcase.match(source_name.downcase)}
  end

  def search_for_sources
    card_name = self.sanitized_name
    attachment_names = self.attachments
    source = find_matching_source(card_name)
    if attachment_names.present?
      source = find_matching_source(attachment_names)
    end
    self.source = source
  end
end