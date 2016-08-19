require 'rspec'
require 'spec_helper'

describe 'card/index.html.erb' do
  it "refreshes the page when updating" do
    visit '/'
    click_on("refresh_page")
    page.should have_content("Current")
  end

  it "displays new cards after updating" do
    Card.create!(creator:'5544334455')
    visit '/'
    click_on("refresh_page")
    page.should have_content("5544334455")
  end
end