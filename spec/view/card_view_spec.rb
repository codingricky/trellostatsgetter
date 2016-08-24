require 'rspec'
require 'spec_helper'

describe 'card/index.html.erb' do
  it "should display the correct page" do
    expect_any_instance_of(CardsController).to receive(:get_cards).and_return([])
    visit '/'
    page.should have_content("current Trello cards")
  end

  it "displays card stats upon loading" do
    card_struct = OpenStruct.new
    card_struct.name = 'Michael'
    card_struct.id = '1'
    expect_any_instance_of(CardsController).to receive(:get_cards).and_return([ card_struct ])
    visit '/'
    page.should have_content('Michael')
  end
end