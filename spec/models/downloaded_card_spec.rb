require 'rspec'
require 'spec_helper'

describe DownloadedCard do
  it 'saves to the db' do
    DownloadedCard.create
    DownloadedCard.all.count.should eq(1)
  end

  it 'saves with a name field (string)' do
    DownloadedCard.create(name: 'Vinny')
    DownloadedCard.first.name.should eq('Vinny')
  end
end