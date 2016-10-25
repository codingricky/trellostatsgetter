Given(/^My Trello board is empty$/) do
  board = SpecsHelper.create_empty_board
  member = Member.new
  member.boards = [ board ]
  Trello::Member.stub(:find).and_return(member)
  list_of_actions = []
  ActionService.stub(:get_actions).and_return(list_of_actions)
end

When(/^I am logged in as a DiUS employee$/) do
  @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
  login_as(@current_user, :scope => :user)
  visit('/')
end

And(/^I navigate to the index page for cards$/) do
  visit('/')
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'Listing cards'
  logout
end

Given(/^I have a card named Michael$/) do
  @card_name = 'Michael'
  @list_name = 'Yay'
  @action_date = Time.parse('1/1/1991')
  board = SpecsHelper.create_board_with_card(@card_name, @list_name, @action_date)
  test_action = Action.new('createCard', '1', @action_date)
  list_of_actions = [ test_action ]
  ActionService.stub(:get_actions).and_return(list_of_actions)
  member = Member.new
  member.boards = [ board ]
  Trello::Member.stub(:find).and_return(member)
end

Then(/^I should see a card named Michael$/) do
  page.should have_content @card_name
  page.should have_content @list_name
  page.should have_content @action_date.to_datetime.strftime('%d %b %Y')
  page.should have_content 'This card is not placed in an end lane.'
  logout
end

Given(/^I have a card that is one day old, and a card that is three days old$/) do
  now = Date.today
  yesterday = (now - 1).to_time
  three_days_ago = (now - 3).to_time

  @list_name = 'Backlog List'
  @list_id = '100'
  @list = List.new(@list_id, @list_name)

  @younger_card_name = 'One Day Old Card'
  @younger_action_date = yesterday
  @younger_card_id = '1'
  @younger_create_action = Action.new('createCard', @younger_card_id, @younger_action_date)

  @older_card_name = 'Three Days Old Card'
  @older_action_date = three_days_ago
  @older_card_id = '2'
  @older_create_action = Action.new('createCard', @older_card_id, @older_action_date)

  @older_card = Card.new(name: @older_card_name, id: @older_card_id, list_id: @list_id, list_name: @list_name)
  @younger_card = Card.new(name: @younger_card_name, id: @younger_card_id, list_id: @list_id, list_name: @list_name)

  board = Board.new
  board.lists = [ @list ]
  list_of_actions = [ @older_create_action, @younger_create_action ]
  board.actions = [ list_of_actions ]
  board.cards = [ @older_card, @younger_card ]

  member = Member.new
  member.boards = [ board ]

  ActionService.stub(:get_actions).and_return(list_of_actions)
  Trello::Member.stub(:find).and_return(member)
end

And(/^I filter the cards that are more than two days old$/) do
  page.should have_content @younger_card_name
  page.should have_content @older_card_name
  fill_in 'days_old', :with => '2'
  click_button 'Filter'
end

Then(/^I should only see the card that is one day old$/) do
  page.should have_content @younger_card_name
  page.should_not have_content @older_card_name
end