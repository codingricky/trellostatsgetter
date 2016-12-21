class LastUpdatedTime < ActiveRecord::Base

  def self.current
    LastUpdatedTime.first
  end

  def self.update_time
    last_run = self.current
    last_run.time = DateTime.current
    last_run.save!
  end
end