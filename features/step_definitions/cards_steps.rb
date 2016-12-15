Before do
  ConfigService.stub(:starting_lanes).and_return(['starting', 'another starting lane'])
  ConfigService.stub(:finishing_lanes).and_return(['finishing', 'another finishing lane'])
  ConfigService.stub(:source_names).and_return(['source'])
end

Given(/^My Trello board is empty$/) do
  # Fake a Trello board for each location.
  board = OpenStruct.new
  board.name = 'Sydney - Software Engineers'
  board.id = '55ac308c4ae6522bbe90f501'
  board.cards = [ ]
  board.lists = [ ]
  other_board = OpenStruct.new
  other_board.name = 'Melbourne Recruitment Pipeline'
  other_board.id = '5302d67d65706eef448e5806'
  other_board.cards = [ ]
  other_board.lists = [ ]
  # Assign the boards to a fake member.
  member = OpenStruct.new
  member.boards = [ board, other_board ]
  # Stub the Trello response with the fake data.
  list_of_actions = []
  Trello::Member.stub(:find).and_return(member)
  Trello::Action.stub(:search).with(any_args).and_return([['ignore this string', member.boards.first.cards]])
  ActionService.stub(:get_actions_from_board_before).and_return(list_of_actions)
  visit '/update'
end

When(/^I am logged in as an employee$/) do
  @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
  login_as(@current_user, :scope => :user)
end

When(/^I navigate to the index page for cards$/) do
  visit '/'
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'Listing cards'
  logout
end

Given(/^I have a card named Michael$/) do
  # Fake a card named Michael.
  @card = OpenStruct.new(id: '1',
                 name: 'Michael',
                 list_id: '1',
                 url: 'www.test.com')
  # Fake the list it lives in.
  @list = OpenStruct.new(id: '1', name: ConfigService.starting_lanes.first)
  # Fake the action that created it.
  @action = OpenStruct.new(type: 'createCard',
                          date: DateTime.current - 1,
                          data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                 'card' =>
                                     {'id' => @card.id}})
  # Fake an empty board for each location.
  board = OpenStruct.new
  board.name = 'Sydney - Software Engineers'
  board.id = '55ac308c4ae6522bbe90f501'
  board.cards = [ @card ]
  board.lists = [ @list ]
  board.actions = [ @action ]
  other_board = OpenStruct.new
  other_board.name = 'Melbourne Recruitment Pipeline'
  other_board.id = '5302d67d65706eef448e5806'
  other_board.cards = [ ]
  other_board.lists = [ ]
  # Assign the boards to a fake member.
  member = OpenStruct.new
  member.boards = [ board, other_board ]
  # Stub the Trello response with the fake data.
  list_of_actions = [ @action ]
  Trello::Member.stub(:find).and_return(member)
  Trello::Action.stub(:search).and_return([['ignore this string', member.boards.first.cards]])
  Trello::Action.stub(:search).with("board:5302d67d65706eef448e5806 edited:#{((DateTime.now.to_date - (DateTime.civil_from_format :local, 2001).to_date).to_i + 1)}", opts = {cards_limit: 1000}).and_return([['ignore this string', []]])
  ActionService.stub(:get_actions_from_board_before).and_return(list_of_actions)
  visit '/update'
end

Then(/^I should see a card named Michael$/) do
  visit '/'
  page.should have_content @card.name
  page.should have_content @list.name
  page.should have_content @action.date.to_datetime.strftime('%d %b %Y')
  page.should have_content 'This card is not placed in an end lane.'
  logout
end

Given(/^I have a card that is one day old, and a card that is five days old$/) do
  # Fake the cards.
  @young_card = OpenStruct.new(id: '1',
                               name: 'Younger Card',
                               list_id: '1',
                               url: 'www.test.com')
  @old_card = OpenStruct.new(id: '2',
                             name: 'Older Card',
                             list_id: '1',
                             url: 'www.test_two.com')
  # Fake the list they live in.
  @list = OpenStruct.new(id: '1', name: ConfigService.starting_lanes.first)
  # Fake the actions that created them.
  @young_action = OpenStruct.new(type: 'createCard',
                           date: DateTime.current - 1,
                           data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                  'card' =>
                                      {'id' => @young_card.id}})
  @old_action = OpenStruct.new(type: 'createCard',
                           date: DateTime.current - 5,
                           data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                  'card' =>
                                      {'id' => @old_card.id}})
  # Fake an empty board for each location.
  board = OpenStruct.new
  board.name = 'Sydney - Software Engineers'
  board.id = '55ac308c4ae6522bbe90f501'
  board.cards = [ @young_card, @old_card ]
  board.lists = [ @list ]
  board.actions = [ @young_action, @old_action ]
  other_board = OpenStruct.new
  other_board.name = 'Melbourne Recruitment Pipeline'
  other_board.id = '5302d67d65706eef448e5806'
  other_board.cards = [ ]
  other_board.lists = [ ]
  # Assign the boards to a fake member.
  member = OpenStruct.new
  member.boards = [ board, other_board ]
  # Stub the Trello response with the fake data.
  list_of_actions = [ @young_action, @old_action ]
  Trello::Member.stub(:find).and_return(member)
  Trello::Action.stub(:search).and_return([['ignore this string', member.boards.first.cards]])
  Trello::Action.stub(:search).with("board:5302d67d65706eef448e5806 edited:#{((DateTime.now.to_date - (DateTime.civil_from_format :local, 2001).to_date).to_i + 1)}", opts = {cards_limit: 1000}).and_return([['ignore this string', []]])
  ActionService.stub(:get_actions_from_board_before).and_return(list_of_actions)
  visit '/update'
end

When(/^I filter the cards that are more than two days old$/) do
  visit '/'
  page.should have_content @young_card.name
  page.should have_content @old_card.name
  fill_in 'days_old', :with => '3'
  click_button 'Submit'
end

Then(/^I should only see the card that is one day old$/) do
  page.should have_content @young_card.name
  page.should_not have_content @old_card.name
end

Given(/^I am on the first board and have two cards - one from each board$/) do
  # Fake the cards.
  @l1_card = OpenStruct.new(id: '1',
                               name: 'Location 1 Card',
                               list_id: '1',
                               url: 'www.test.com')
  @l2_card = OpenStruct.new(id: '2',
                             name: 'Location 2 Card',
                             list_id: '1',
                             url: 'www.test_two.com')
  # Fake the list they live in.
  @list = OpenStruct.new(id: '1', name: ConfigService.starting_lanes.first)
  # Fake the actions that created them.
  @l1_action = OpenStruct.new(type: 'createCard',
                                 date: DateTime.current - 1,
                                 data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                        'card' =>
                                            {'id' => @l1_card.id}})
  @l2_action = OpenStruct.new(type: 'createCard',
                               date: DateTime.current - 1,
                               data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                      'card' =>
                                          {'id' => @l2_card.id}})
  # Fake an empty board for each location.
  board = OpenStruct.new
  board.name = 'Sydney - Software Engineers'
  board.id = '55ac308c4ae6522bbe90f501'
  board.cards = [ @l1_card ]
  board.lists = [ @list ]
  board.actions = [ @l1_action ]
  other_board = OpenStruct.new
  other_board.name = 'Melbourne Recruitment Pipeline'
  other_board.id = '5302d67d65706eef448e5806'
  other_board.cards = [ @l2_card ]
  other_board.lists = [ @list ]
  other_board.actions = [ @l2_action ]
  # Assign the boards to a fake member.
  member = OpenStruct.new
  member.boards = [ board, other_board ]
  # Stub the Trello response with the fake data.
  list_of_actions = [ @l1_action, @l2_action ]
  Trello::Member.stub(:find).and_return(member)
  Trello::Action.stub(:search).and_return([['ignore this string', member.boards.first.cards]])
  Trello::Action.stub(:search).with("board:5302d67d65706eef448e5806 edited:#{((DateTime.now.to_date - (DateTime.civil_from_format :local, 2001).to_date).to_i + 1)}", opts = {cards_limit: 1000}).and_return([['ignore this string', []]])
  ActionService.stub(:get_actions_from_board_before).and_return(list_of_actions)
  visit '/update'
end

When(/^I click on the other location button and hit Submit$/) do
  visit '/'
  page.should have_content @l1_card.name
  page.should_not have_content @l2_card.name
  choose 'location_Melbourne_Recruitment_Pipeline'
  click_button 'Submit'
end

Then(/^I can see the card from the other location$/) do
  page.should have_content @l1_card.name
end

Then(/^I can not see the card from the first board anymore$/) do
  page.should_not have_content @l2_card.name
end

Given(/^I am on the first board and can see an active and inactive card$/) do
  # Fake the cards.
  @active_card = OpenStruct.new(id: '1',
                               name: 'Active Card',
                               list_id: '1',
                               url: 'www.test.com')
  @inactive_card = OpenStruct.new(id: '2',
                             name: 'Finished Card',
                             list_id: '2',
                             url: 'www.test_two.com')
  # Fake the list they live in.
  @list = OpenStruct.new(id: '1', name: ConfigService.starting_lanes.first)
  @finish_list = OpenStruct.new(id: '2', name: ConfigService.finishing_lanes.first)
  # Fake the actions that created them.
  @active_action = OpenStruct.new(type: 'createCard',
                                 date: DateTime.current - 1,
                                 data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                        'card' =>
                                            {'id' => @active_card.id}})
  @inactive_action = OpenStruct.new(type: 'createCard',
                               date: DateTime.current - 2,
                               data: {'list' =>{'name' => ConfigService.starting_lanes.first},
                                      'card' =>
                                          {'id' => @inactive_card.id}})
  @inactive_finish_action = OpenStruct.new(type: 'updateCard',
                               date: DateTime.current - 1,
                               data: {'listAfter' =>{'name' => ConfigService.finishing_lanes.first},
                                              'card' =>
                                                  {'id' =>@inactive_card.id}})
  # Fake an empty board for each location.
  board = OpenStruct.new
  board.name = 'Sydney - Software Engineers'
  board.id = '55ac308c4ae6522bbe90f501'
  board.cards = [ @active_card, @inactive_card ]
  board.lists = [ @list, @finish_list ]
  board.actions = [ @active_action, @inactive_action, @inactive_finish_action ]
  other_board = OpenStruct.new
  other_board.name = 'Melbourne Recruitment Pipeline'
  other_board.id = '5302d67d65706eef448e5806'
  other_board.cards = [ ]
  other_board.lists = [ ]
  # Assign the boards to a fake member.
  member = OpenStruct.new
  member.boards = [ board, other_board ]
  # Stub the Trello response with the fake data.
  list_of_actions = [ @active_action, @inactive_action, @inactive_finish_action ]
  Trello::Member.stub(:find).and_return(member)
  Trello::Action.stub(:search).and_return([['ignore this string', member.boards.first.cards]])
  Trello::Action.stub(:search).with("board:5302d67d65706eef448e5806 edited:#{((DateTime.now.to_date - (DateTime.civil_from_format :local, 2001).to_date).to_i + 1)}", opts = {cards_limit: 1000}).and_return([['ignore this string', []]])
  ActionService.stub(:get_actions_from_board_before).and_return(list_of_actions)
  visit '/update'
end

When(/^I click on the Active Only button and hit Submit$/) do
  visit '/'
  choose 'show_only_all_cards'
  click_button 'Submit'
  page.should have_content @active_card.name
  page.should have_content @inactive_card.name
  choose 'show_only_active_cards'
  click_button 'Submit'
end

Then(/^I can see the active card$/) do
  page.should have_content @active_card.name
end

Then(/^I can not see the inactive card anymore$/) do
  page.should_not have_content @inactive_card.name
end