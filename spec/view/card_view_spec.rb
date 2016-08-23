require 'rspec'
require 'spec_helper'

describe 'card/index.html.erb' do
  it "should display the correct page" do
    visit '/'
    page.should have_content("current Trello cards")
  end

  it "displays card stats upon loading" do
    @cards = 'GIVE IT AN ARRAY'
    visit '/'
    page.should have_content('WHATEVER WAS IN THE ARRAY')
  end
end