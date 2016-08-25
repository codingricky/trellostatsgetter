require 'rspec'
require 'spec_helper'

describe 'cards/index', type: :view do
  it "should display the correct page" do
    render
    rendered.should match /current Trello cards/
  end

  it "should display to the user 'No cards.' when @cards is nil" do
    render
    rendered.should match /No cards/
  end

  it "displays card stats upon loading" do
    card_struct = OpenStruct.new
    card_struct.name = 'Michael'
    card_struct.id = '1'
    @cards = [ card_struct ]
    assign(:cards, @cards)
    render
    rendered.should match /Michael/
  end
end