Given(/^I am on the index page for cards$/) do
  visit('/')
end

Then(/^I should see the index for cards$/) do
  expect(page).to have_content 'Current Trello Cards'
end

##

Given(/^I have cards by TestersEd1 and TestersEd2$/) do
  Card.create!(creator:'TestersEd1')
  Card.create!(creator:'TestersEd2')
end

When(/^I update the index of cards/) do
  visit('/')
end

Then(/^I should see cards by TestersEd1 and TestersEd2$/) do
  expect(page).to have_content 'TestersEd1'
  expect(page).to have_content 'TestersEd2'
end