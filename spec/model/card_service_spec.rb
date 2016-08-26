require 'rspec'
require 'spec_helper'
require 'trello'

describe CardService do

  card1 = OpenStruct.new
  card1.name = 'Michael'
  card1.id = '1'
  card1.list_id = '1'
  card1.list_name = 'Yay'

  card2 = OpenStruct.new
  card2.name = 'Michael2'
  card2.id = '2'
  card2.list_id = '2'
  card2.list_name = 'Nay'

  list1 = OpenStruct.new
  list1.id = '1'
  list1.name = 'Yay'

  list2 = OpenStruct.new
  list2.id = '2'
  list2.name = 'Nay'

  board1 = OpenStruct.new
  member = OpenStruct.new

  context "receives a card from trello" do
    before do
      board1.cards = [ card1 ]
      board1.lists = [ list1, list2 ]
      member.boards = [ board1 ]
      Trello::Member.should_receive(:find).and_return(member)
    end

    it "puts the card's name and id into an array" do
      CardService.all == 1
      Card.name == card1.name
    end
  end

  context "receives multiple cards from trello" do
    before do
      board1.cards = [ card1, card2 ]
      board1.lists = [ list1, list2 ]
      member.boards = [ board1 ]
      Trello::Member.should_receive(:find).and_return(member)
    end

    it "puts the cards' name and id into an array" do
      CardService.all == 2
      Card.name == (card1.name + card2.name)
    end
  end

  context "receives no cards from trello" do
    before do
      board1.cards = [ ]
      board1.lists = [ list1, list2 ]
      member.boards = [ board1 ]
      Trello::Member.should_receive(:find).and_return(member)
    end

    it "puts nothing into an array" do
      CardService.all.should eq([ ])
    end
  end
end