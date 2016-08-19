require 'rspec'
require 'spec_helper'

describe Card do

  card2 = OpenStruct.new
  card2.name = 'Do this and that2.'
  card2.id = '54mp132'
  card1 = OpenStruct.new
  card1.name = 'Do this and that.'
  card1.id = '54mp13'
  board1 = OpenStruct.new
  board2 = OpenStruct.new
  me = OpenStruct.new

  context "receives a card from trello" do
    it "saves a card to the db" do
      board1.cards = [ card1 ]
      me.boards = [ board1 ]
      Card.find_board(me)
      Card.all.count.should eq(1)
    end

    it "deletes a duplicate card" do
      board1.cards = [ card1, card1 ]
      me.boards = [ board1 ]
      Card.find_board(me)
      Card.all.count.should eq(2)
      Card.delete_duplicates
      Card.all.count.should eq(1)
    end
  end
end