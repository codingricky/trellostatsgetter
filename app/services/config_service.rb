class ConfigService
  def self.starting_lanes
    ENV['STARTING_LANE'].split('|')
  end

  def self.finishing_lanes
    ENV['FINISHING_LANES'].split('|')
  end

  def self.source_names
    ENV['SOURCE_NAMES'].split('|')
  end
end