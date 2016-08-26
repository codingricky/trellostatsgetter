Given(/^I am on the index page for cards$/) do
  list1 = OpenStruct.new
  list1.id = '2'
  list1.name = 'Yay'
  board1 = OpenStruct.new
  board1.cards = [ ]
  board1.lists = [ list1 ]
  me = OpenStruct.new
  me.boards = [ board1 ]
  Trello::Member.should_receive(:find).and_return(me)
  visit('/')
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'current Trello cards'
end

##

Given(/^I have a card named Michael$/) do
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
  Trello::Member.should_receive(:find).and_return(me)
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  page.should have_content 'Michael'
  page.should have_content '1'
  page.should have_content 'Yay'
  page.should have_content '1/1/1990'
end