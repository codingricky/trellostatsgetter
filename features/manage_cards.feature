Feature: Manage cards.
  In order to keep a record of Trello card statistics
  As a Trello user
  I want to download and organize card information into meaningful data.

  Scenario: Viewing the Trello card index.
    Given I am logged in as a DiUS employee
    When My Trello board is empty
    And I navigate to the index page for cards
    Then I should see the index for cards

  Scenario: Seeing new cards in the index list.
    Given I am logged in as a DiUS employee
    When I have a card named Michael
    And I update the index of cards
    Then I should see a card named Michael