Feature: Manage cards.
  In order to keep a record of Trello card statistics
  As a Trello user
  I want to download and organize card information into meaningful data.

  Scenario: Viewing the Trello card index.
    Given I am on the index page for cards
    Then I should see the index for cards

  Scenario: Seeing new cards in the index list.
    Given I have a cards named Michael
    When I update the index of cards
    Then I should see a card named Michael

  Scenario: Display the duration of the card's life in a particular swim lane.
    Given x
    When y
    Then z

  Scenario: Display the number of cards in a particular swim lane at a given point in time.
    Given x
    When y
    Then z