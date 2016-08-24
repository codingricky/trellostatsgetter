card1 = OpenStruct.new
board1 = OpenStruct.new
me = OpenStruct.new
card1.name = 'Michael'
card1.id = '1'
board1.cards = [ card1 ]
me.boards = [ board1 ]

Given(/^I am on the index page for cards$/) do
  Card.should_receive(:find_trello_data).and_return(me)
  visit('/')
end

Then(/^I should see the index for cards$/) do
  expect(page).to have_content 'current Trello cards'
end

##

Given(/^I have a cards named Michael$/) do
  Card.should_receive(:find_trello_data).and_return(me)
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  expect(page).to have_content 'Michael'
end