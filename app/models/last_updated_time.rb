class LastUpdatedTime < ActiveRecord::Base

  def self.current
    LastUpdatedTime.first.time
  end
end