Given(/^I am on the index page for cards$/) do
  visit('/')
end

Then(/^I should see the index for cards$/) do
  expect(page).to have_content 'current Trello cards'
end

##

Given(/^I have a cards named Michael$/) do
  cardStruct = OpenStruct.new
  cardStruct.name = 'Michael'
  @cards = [ cardStruct ]
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  expect(page).to have_content 'Michael'
end