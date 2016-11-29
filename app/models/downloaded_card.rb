class DownloadedCard < ActiveRecord::Base
  before_save :sanitize_name

  def duration_in_days
    return nil if self.start_date.nil?

    start_date = self.start_date
    end_date = (self.end_date.nil? ? DateTime.now : self.end_date)
    (end_date.to_date - start_date.to_date).to_i
  end

  def sanitize_name
    self.sanitized_name = self.sanitized_name.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '')
  end
end