Feature: Manage cards.
  In order to keep a record of Trello card statistics
  As a Trello user
  I want to download and organize card information into meaningful data.

  Scenario: Viewing the Trello card index.
    Given My Trello board is empty
    When I am logged in as an employee
    And I navigate to the index page for cards
    Then I should see the index for cards

  Scenario: Seeing new cards in the index list.
    Given I have a card named Michael
    When I am logged in as an employee
    Then I should see a card named Michael

  Scenario: Seeing filtered cards in the index list.
    Given I have a card that is one day old, and a card that is five days old
    And I am logged in as an employee
    When I filter the cards that are more than two days old
    Then I should only see the card that is one day old

  Scenario: Switching to the other location board.
    Given I am on the first board and have two cards - one from each board
    And I am logged in as an employee
    When I click on the other location button and hit Submit
    Then I can see the card from the other location
    And I can not see the card from the first board anymore

  Scenario: Showing only active cards.
    Given I am on the first board and can see an active and inactive card
    And I am logged in as an employee
    When I click on the Active Only button and hit Submit
    Then I can see the active card
    And I can not see the inactive card anymore