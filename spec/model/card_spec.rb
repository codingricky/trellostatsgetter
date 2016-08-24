require 'rspec'
require 'spec_helper'

describe Card do

  card_struct = OpenStruct.new
  card_struct.name = 'Michael'
  card_struct.id = '1'
  card_struct.list_id = nil
  card_struct2 = OpenStruct.new
  card_struct2.name = 'Michaele'
  card_struct2.id = '2'
  card_struct2.list_id = nil

  card2 = OpenStruct.new
  card2.name = 'Michaele'
  card2.id = '2'
  card2.list_id = nil
  card1 = OpenStruct.new
  card1.name = 'Michael'
  card1.id = '1'
  card1.list_id = nil
  board1 = OpenStruct.new
  board2 = OpenStruct.new
  me = OpenStruct.new

  context "receives a card from trello" do
    before do
      board1.cards = [ card1 ]
      me.boards = [ board1, board2 ]
    end

    it "gets the first board" do
      Card.find_board(me).should eq(board1)
    end

    it "puts the card's name and id into an array" do
      Card.find_cards(board1).should eq([ card_struct ])
    end
  end

  context "receives multiple cards from trello" do
    before do
      board1.cards = [ card1, card2 ]
      me.boards = [ board1, board2 ]
    end

    it "gets the first board" do
      Card.find_board(me).should eq(board1)
    end

    it "puts the cards' name and id into an array" do
      Card.find_cards(board1).should eq([ card_struct, card_struct2 ])
    end
  end

  context "receives no cards from trello" do
    before do
      board1.cards = [ ]
      me.boards = [ board1, board2 ]
    end

    it "gets the first board" do
      Card.find_board(me).should eq(board1)
    end

    it "puts the cards' name and id into an array" do
      Card.find_cards(board1).should eq([ ])
    end
  end
end