Feature: Manage cards.
  In order to keep a record of Trello card statistics
  As a Trello user
  I want to download and organize card information into meaningful data.

  Scenario: Viewing the Trello card index.
    Given My Trello board is empty
    When I am logged in as a DiUS employee
    And I navigate to the index page for cards
    Then I should see the index for cards

  Scenario: Seeing new cards in the index list.
    Given I have a card named Michael
    When I am logged in as a DiUS employee
    Then I should see a card named Michael

  Scenario: Seeing filtered cards in the index list.
    Given I have a card that is one day old, and a card that is three days old
    And I am logged in as a DiUS employee
    When I filter the cards that are more than two days old
    Then I should only see the card that is one day old

  Scenario: Invalid filter "days_ago" value.
    Given I have a card that is one day old, and a card that is three days old
    And I am logged in as a DiUS employee
    When I filter the cards with value 0
    Then I am given an error message telling me to enter a valid value

  Scenario: Switching to the Melbourne board.
    Given I am on the Sydney board and have two cards
    And I am logged in as a DiUS employee
    When I click on the Melbourne button and hit Submit
    Then I can see the card from Melbourne
    And I can not see the card from Sydney anymore

  Scenario: Showing only active cards.
    Given I am on the Sydney board and can see an active and inactive card
    And I am logged in as a DiUS employee
    When I click on the Active Only button and hit Submit
    Then I can see the active card
    And I can not see the inactive card anymore

  Scenario: Downloading Sydney cards.
    Given I am on the Sydney board and can see an active and inactive card
    And I am logged in as a DiUS employee
    When I navigate to download
    Then The cards are saved to the db
    And A blank page is loaded