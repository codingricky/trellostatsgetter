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