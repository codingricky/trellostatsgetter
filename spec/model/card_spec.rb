require 'rspec'
require 'spec_helper'

describe Card do
  context "receives a card from trello" do

    card1 = OpenStruct.new
    card1.name = 'Do this and that.'
    card1.id = '54mp13'
    board1 = OpenStruct.new
    board1.cards = [ card1 ]
    me = OpenStruct.new

    it "saves a card to the db" do
      me.boards = [ board1 ]
      # Card.find_board(me)
      allow_any_instance_of(Trello::Member).to receive('***REMOVED***').and_return(me)
      Card.get_trello_authentication
      Card.all.count.should eq(1)
    end

    it "deletes a duplicate card" do
      me.boards = [ board1, board1 ]
      # allow_any_instance_of(Trello::Member).to receive(:return(me))
      Card.get_trello_authentication
      Card.all.count.should eq(2)
      Card.delete_duplicates
      Card.all.count.should eq(1)
    end
  #   STILL NEED TO TEST EDGE CASES!
  end
end