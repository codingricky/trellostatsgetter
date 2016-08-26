require 'rspec'
require 'spec_helper'
require 'trello'

describe CardService do
  before do
    @card1 = OpenStruct.new
    @card1.name = 'Michael'
    @card1.id = '1'
    @card1.list_id = '1'
    @card1.list_name = 'Yay'

    @card2 = OpenStruct.new
    @card2.name = 'Michael2'
    @card2.id = '2'
    @card2.list_id = '2'
    @card2.list_name = 'Nay'

    @list1 = OpenStruct.new
    @list1.id = '1'
    @list1.name = 'Yay'

    @list2 = OpenStruct.new
    @list2.id = '2'
    @list2.name = 'Nay'

    @board1 = OpenStruct.new
    @member = OpenStruct.new
  end

  describe "receives a card from trello" do
    before do
      @board1.cards = [ @card1 ]
      @board1.lists = [ @list1, @list2 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's name, id, swimlane, and startdate into an array" do
      cards = CardService.all
      cards.first.name.should eq(@card1.name)
      cards.first.id.should eq(@card1.id)
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card1.list_name)
      cards.first.start_date.should eq(@card1.start_date)
    end
  end

  context "receives multiple cards from trello" do
    before do
      @board1.cards = [ @card1, @card2 ]
      @board1.lists = [ @list1, @list2 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the cards' name, id, swimlane, and startdate into an array" do
      cards = CardService.all
      cards.first.name.should eq(@card1.name)
      cards.first.id.should eq(@card1.id)
      cards.first.list_name.should eq(@card1.list_name)
      cards.first.start_date.should eq(@card1.start_date)
      cards.last.name.should eq(@card2.name)
      cards.last.id.should eq(@card2.id)
      cards.last.list_name.should eq(@card2.list_name)
      cards.last.start_date.should eq(@card2.start_date)
      cards.count.should eq(2)
    end
  end

  context "receives no cards from trello" do
    before do
      @board1.cards = [ ]
      @board1.lists = [ @list1, @list2 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

  it "puts nothing into an array" do
    cards = CardService.all
    cards.count.should eq(0)
    end
  end
end