require 'rspec'
require 'spec_helper'
require 'trello'

describe ConfigService do
  it 'should split the starting lanes' do
    ENV['STARTING_LANE'] = 'starting lane 1|starting lane 2'
    ConfigService.starting_lanes.count.should eql(2)
    ConfigService.starting_lanes.first.should eql('starting lane 1')
    ConfigService.starting_lanes.last.should eql('starting lane 2')
  end

  it 'should split the finishing lanes' do
    ENV['FINISHING_LANES'] = 'finishing lane 1|finishing lane 2'
    ConfigService.finishing_lanes.count.should eql(2)
    ConfigService.finishing_lanes.first.should eql('finishing lane 1')
    ConfigService.finishing_lanes.last.should eql('finishing lane 2')
  end

  it 'should split the source names' do
    ENV['SOURCE_NAMES'] = 'source 1|source 2'
    ConfigService.source_names.count.should eql(2)
    ConfigService.source_names.first.should eql('source 1')
    ConfigService.source_names.last.should eql('source 2')
  end

end
