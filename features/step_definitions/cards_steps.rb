card1 = OpenStruct.new
card1.name = 'Michael'
card1.id = '1'
card1.list_id = '2'

list1 = OpenStruct.new
list1.id = '2'
list1.name = 'Yay'

board1 = OpenStruct.new
board1.cards = [ card1 ]
board1.lists = [ list1 ]

me = OpenStruct.new
me.boards = [ board1 ]

Given(/^I am on the index page for cards$/) do
  CardService.should_receive(:find_member).and_return(me)
  visit('/')
end

Then(/^I should see the index for cards$/) do
  expect(page).to have_content 'current Trello cards'
end

##

Given(/^I have a card named Michael$/) do
  CardService.should_receive(:find_member).and_return(me)
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  expect(page).to have_content 'Michael'
end