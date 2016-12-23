class ConfigService
  def self.finishing_lanes
    ENV['FINISHING_LANES'].split('|')
  end

end