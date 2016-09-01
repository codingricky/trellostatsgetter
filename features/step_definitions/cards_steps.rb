Given(/^I am on the index page for cards$/) do
  board = Board.new
  board.cards = [ ]
  board.lists = [ ]
  member = Member.new
  member.boards = [ board ]
  Trello::Member.should_receive(:find).and_return(member)
  visit('/')
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'current Trello cards'
end

##

card_name = 'Michael'
card_id = '1'
card_list_id = '2'
action_type = 'createCard'
action_card_id = '1'
action_date = '1/1/1991'
list_id = '2'
list_name = 'Yay'

Given(/^I have a card named Michael$/) do
  board = Board.new
  list = List.new(list_id, list_name)
  action = Action.new(action_type, action_card_id, action_date)
  board.lists = [ list ]
  board.actions = [ action ]
  card = Card.new(board, card_name, card_id, card_list_id)
  board.cards = [ card ]
  member = Member.new
  member.boards = [ board ]
  Trello::Member.should_receive(:find).and_return(member)
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  page.should have_content card_name
  page.should have_content list_name
  page.should have_content action_date
end