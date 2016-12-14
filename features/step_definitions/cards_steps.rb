Before do
  ConfigService.stub(:starting_lanes).and_return(['starting', 'another starting lane'])
  ConfigService.stub(:finishing_lanes).and_return(['finishing', 'another finishing lane'])
  ConfigService.stub(:source_names).and_return(['source'])
end

Given(/^My Trello board is empty$/) do
  board = SpecsHelper.create_empty_board
  melb_board = SpecsHelper.create_empty_melb_board
  member = Member.new
  member.boards = [ board, melb_board ]
  Trello::Member.stub(:find).and_return(member)
  list_of_actions = []
  ActionService.stub(:get_actions).and_return(list_of_actions)
  visit '/update'
end

When(/^I am logged in as a DiUS employee$/) do
  @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
  login_as(@current_user, :scope => :user)
  visit('/')
end

And(/^I navigate to the index page for cards$/) do
  visit '/update'
  visit('/')
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'Listing cards'
  logout
end

Given(/^I have a card named Michael$/) do
  @card_name = 'Michael'
  @list_name = 'Yay'
  @action_date = (DateTime.now - 1)
  board = SpecsHelper.create_board_with_card(@card_name, @list_name, @action_date)
  melb_board = SpecsHelper.create_empty_melb_board
  test_action = Action.new('createCard', '1', @action_date)
  list_of_actions = [ test_action ]
  ActionService.stub(:get_actions).and_return(list_of_actions)
  member = Member.new
  member.boards = [ board, melb_board ]
  Trello::Member.stub(:find).and_return(member)
  visit '/update'
end

Then(/^I should see a card named Michael$/) do
  page.should have_content @card_name
  page.should have_content @list_name
  page.should have_content @action_date.to_datetime.strftime('%d %b %Y')
  page.should have_content 'This card is not placed in an end lane.'
  logout
end

Given(/^I have a card that is one day old, and a card that is five days old$/) do
  now = Date.today
  yesterday = (now - 1).to_time
  five_days_old = (now - 5).to_time

  @list_name = 'Backlog List'
  @list_id = '100'
  @list = List.new(@list_id, @list_name)

  @younger_card_name = 'One Day Old Card'
  @younger_action_date = yesterday
  @younger_card_id = '1'
  @younger_create_action = Action.new('createCard', @younger_card_id, @younger_action_date)

  @older_card_name = 'Three Days Old Card'
  @older_action_date = five_days_old
  @older_card_id = '2'
  @older_create_action = Action.new('createCard', @older_card_id, @older_action_date)

  @older_card = OpenStruct.new(name: @older_card_name, id: @older_card_id, list_id: @list_id, list_name: @list_name)
  @younger_card = OpenStruct.new(name: @younger_card_name, id: @younger_card_id, list_id: @list_id, list_name: @list_name)

  board = Board.new

  board.lists = [ @list ]
  list_of_actions = [ @older_create_action, @younger_create_action ]
  board.actions = [ list_of_actions ]
  board.cards = [ @older_card, @younger_card ]
  melb_board = SpecsHelper.create_empty_melb_board
  member = Member.new
  member.boards = [ board, melb_board ]

  ActionService.stub(:get_actions).and_return(list_of_actions)
  Trello::Member.stub(:find).and_return(member)
  visit '/update'
end

And(/^I filter the cards that are more than two days old$/) do
  page.should have_content @younger_card_name
  page.should have_content @older_card_name
  fill_in 'days_old', :with => '3'
  click_button 'Submit'
end

Then(/^I should only see the card that is one day old$/) do
  page.should have_content @younger_card_name
  page.should_not have_content @older_card_name
end

And(/^I filter the cards with value 0$/) do
  page.should have_content @younger_card_name
  page.should have_content @older_card_name
  fill_in 'days_old', :with => '-1'
  click_button 'Submit'
end

Then(/^I am given an error message telling me to enter a valid value$/) do
  page.should_not have_content @younger_card_name
  page.should_not have_content @older_card_name
  page.should have_content 'Error: Please input a valid maximum days value.'
end

Given(/^I am on the Sydney board and have two cards$/) do
  now = Date.today
  yesterday = (now - 1).to_time
  five_days_old = (now - 5).to_time

  @list_name = 'Resumes To Be Screened '
  @list_id = '101'
  @list = List.new(@list_id, @list_name)

  @sydney_card_name = 'Someone applying for a job in Sydney'
  @sydney_action_date = yesterday
  @sydney_card_id = '1'
  @sydney_create_action = Action.new('createCard', @sydney_card_id, @sydney_action_date)

  @melbourne_card_name = 'Someone applying for a job in Melbourne'
  @melbourne_action_date = five_days_old
  @melbourne_card_id = '2'
  @melbourne_create_action = Action.new('createCard', @melbourne_card_id, @melbourne_action_date)

  @melbourne_card = OpenStruct.new(name: @melbourne_card_name, id: @melbourne_card_id, list_id: @list_id, list_name: @list_name)
  @sydney_card = OpenStruct.new(name: @sydney_card_name, id: @sydney_card_id, list_id: @list_id, list_name: @list_name)

  sydney_board = Board.new
  sydney_board.lists = [ @list ]
  list_of_actions = [ @sydney_create_action, @melbourne_create_action ]
  sydney_board.actions = [ list_of_actions ]
  sydney_board.cards = [ @sydney_card ]

  melbourne_board = Board.new
  melbourne_board.name = 'Melbourne Recruitment Pipeline'
  melbourne_board.id = '5302d67d65706eef448e5806'
  melbourne_board.lists = [ @list ]
  melbourne_board.actions = [ list_of_actions ]
  melbourne_board.cards = [ @melbourne_card ]

  member = Member.new
  member.boards = [ sydney_board, melbourne_board ]

  ActionService.stub(:get_actions).and_return(list_of_actions)
  Trello::Member.stub(:find).and_return(member)
  visit '/update'
end

When(/^I click on the Melbourne button and hit Submit$/) do
  page.should have_content @sydney_card_name
  page.should_not have_content @melbourne_card_name
  choose 'location_Melbourne_Recruitment_Pipeline'
  click_button 'Submit'
end

Then(/^I can see the card from Melbourne$/) do
  page.should have_content @melbourne_card_name
end

And(/^I can not see the card from Sydney anymore$/) do
  page.should_not have_content @sydney_card_name
end

Given(/^I am on the Sydney board and can see an active and inactive card$/) do
  now = Date.today
  yesterday = (now - 1).to_time
  five_days_old = (now - 5).to_time

  @list_name = ConfigService.starting_lanes.first
  @list_id = '101'
  @list = List.new(@list_id, @list_name)
  @list_end_name = ConfigService.finishing_lanes.first
  @list_end_id = '102'
  @list_end = List.new(@list_end_id, @list_end_name)

  @active_card_name = 'Someone applying for a job'
  @active_action_date = yesterday
  @active_card_id = '1'
  @active_create_action = Action.new('createCard', @active_card_id, @active_action_date)

  @inactive_card_name = 'Someone got hired for a job'
  @inactive_action_date = five_days_old
  @inactive_end_date = yesterday
  @inactive_card_id = '2'
  @inactive_create_action = Action.new('createCard', @inactive_card_id, @inactive_action_date)
  @inactive_update_action = Action.new('updateCard_finish', @inactive_card_id, @inactive_end_date)

  @inactive_card = OpenStruct.new(name: @inactive_card_name, id: @inactive_card_id, list_id: @list_end_id, list_name: @list_end_name)
  @active_card = OpenStruct.new(name: @active_card_name, id: @active_card_id, list_id: @list_id, list_name: @list_name)

  board = Board.new
  board.lists = [ @list, @list_end ]
  list_of_actions = [ @active_create_action, @inactive_create_action, @inactive_update_action ]
  board.actions = [ list_of_actions ]
  board.cards = [ @active_card, @inactive_card ]
  empty_board = Board.new
  empty_board.name = 'Melbourne Recruitment Pipeline'
  empty_board.id = '5302d67d65706eef448e5806'
  empty_board.lists = []
  empty_board.cards = []
  empty_board.actions = []

  member = Member.new
  member.boards = [ board, empty_board ]

  ActionService.stub(:get_actions).and_return(list_of_actions)
  Trello::Member.stub(:find).and_return(member)
  visit '/update'
end

When(/^I click on the Active Only button and hit Submit$/) do
  choose 'show_only_all_cards'
  click_button 'Submit'
  page.should have_content @active_card_name
  page.should have_content @inactive_card_name
  choose 'show_only_active_cards'
  click_button 'Submit'
end

Then(/^I can see the active card$/) do
  page.should have_content @active_card_name
end

And(/^I can not see the inactive card anymore$/) do
  page.should_not have_content @inactive_card_name
end

When(/^I navigate to download$/) do
  visit '/update'
end

Then(/^The cards are saved to the db$/) do
  DownloadedCard.all.count.should eq(2)
end

Then(/^A blank page is loaded$/) do
  page.status_code.should eq(200)
end