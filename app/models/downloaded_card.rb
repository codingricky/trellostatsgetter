class DownloadedCard < ActiveRecord::Base
  def duration_in_days
    return nil if self.start_date.nil?

    start_date = self.start_date
    end_date = self.start_date.nil? ? DateTime.now : self.end_date
    (end_date.to_date - start_date.to_date).to_i
  end
end