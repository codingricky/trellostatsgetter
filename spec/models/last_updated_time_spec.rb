require 'rspec'
require 'spec_helper'

describe LastUpdatedTime do
  it 'saves to db' do
    LastUpdatedTime.create!
    LastUpdatedTime.all.count.should eq(1)
  end

  it 'saves with a time field (datetime)' do
    LastUpdatedTime.create!(time: (DateTime.civil_from_format :local, 2012))
    LastUpdatedTime.first.time.should eq(DateTime.civil_from_format :local, 2012)
  end
end