require 'rspec'
require 'spec_helper'

describe Card do

  cardStruct = OpenStruct.new
  cardStruct.name = 'Michael'
  cardStruct.id = '1'
  cardStruct2 = OpenStruct.new
  cardStruct2.name = 'Michaele'
  cardStruct2.id = '2'
  cardStructE = OpenStruct.new
  cardStructE.name = 'There was an error contacting the Trello API.'

  card2 = OpenStruct.new
  card2.name = 'Michaele'
  card2.id = '2'
  card1 = OpenStruct.new
  card1.name = 'Michael'
  card1.id = '1'
  board1 = OpenStruct.new
  board2 = OpenStruct.new
  me = OpenStruct.new

  context "receives a card from trello" do
    it "puts the card's name and id into an array" do
      board1.cards = [ card1 ]
      me.boards = [ board1 ]
      Card.find_board(me).should eq([ cardStruct ])
    end
  end

  context "receives multiple cards from trello" do
    it "puts the cards' name and id into an array" do
      board1.cards = [ card1, card2 ]
      me.boards = [ board1 ]
      Card.find_board(me).should eq([ cardStruct, cardStruct2 ])
    end
  end

  context "receives no cards from trello" do
    it "returns an empty array" do
      board1.cards = [ ]
      me.boards = [ board1 ]
      Card.find_board(me).should eq([ ])
    end
  end
end