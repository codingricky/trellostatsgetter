Given(/^I am logged in as a DiUS employee$/) do
  @current_user = User.create!(:email => 'user@dius.com.au', :password => 'password')
  login_as(@current_user, :scope => :user)
end

When(/^My Trello board is empty$/) do
  board = SpecsHelper.create_empty_board
  member = Member.new
  member.boards = [ board ]
  Trello::Member.should_receive(:find).and_return(member)
end

And(/^I navigate to the index page for cards$/) do
  visit('/')
end

Then(/^I should see the index for cards$/) do
  page.should have_content 'Listing cards'
  logout
end

When(/^I have a card named Michael$/) do
  @card_name = 'Michael'
  @list_name = 'Yay'
  @action_date = '1/1/1991'
  board = SpecsHelper.create_board_with_card(@card_name, @list_name, @action_date)
  member = Member.new
  member.boards = [ board ]
  Trello::Member.should_receive(:find).and_return(member)
end

And(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see a card named Michael$/) do
  page.should have_content @card_name
  page.should have_content @list_name
  page.should have_content @action_date.to_datetime.strftime('%d %b %Y')
  page.should have_content 'This card is not placed in an end lane.'
  logout
end