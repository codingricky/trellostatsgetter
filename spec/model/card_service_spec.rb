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

    @action1 = OpenStruct.new
    @action1.type = 'createCard'
    @action1.data = {"list"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"1"}}
    @action1.date = '1/1/1991'

    @action2 = OpenStruct.new
    @action2.type = 'updateCard'
    @action2.data = {"listAfter"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"1"}}
    @action2.date = '1/1/1992'

    @action2later = OpenStruct.new
    @action2later.type = 'updateCard'
    @action2later.data = {"listAfter"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"1"}}
    @action2later.date = '2/1/1992'

    @action3 = OpenStruct.new
    @action3.type = 'createCard'
    @action3.data = {"list"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"2"}}
    @action3.date = '1/1/1993'

    @action4 = OpenStruct.new
    @action4.type = 'updateCard'
    @action4.data = {"listAfter"=>{"name"=>"Resumes to be Screened"},
                     "card"=>
                         {"id"=>"2"}}
    @action4.date = '1/1/1994'

    @board1 = OpenStruct.new
    @member = OpenStruct.new
  end

  context "receives a card from trello that was created in the Resumes swimlane" do
    before do
      @board1.cards = [ @card1 ]
      @board1.lists = [ @list1, @list2 ]
      @board1.actions = [ @action1 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's name, id, swimlane, and startdate into an array" do
      cards = CardService.all
      cards.first.name.should eq(@card1.name)
      cards.first.id.should eq(@card1.id)
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card1.list_name)
      cards.first.start_date.should eq(@action1.date)
    end
  end

  context "receives a card from trello of a card that was moved in to the Resumes to be Screened swimlane" do
    before do
      @board1.cards = [ @card2 ]
      @board1.lists = [ @list1, @list2 ]
      @board1.actions = [ @action3 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's name, id, swimlane, and startdate into an array using the latest movement into the Resumes swimlane as the start date" do
      cards = CardService.all
      cards.first.name.should eq(@card2.name)
      cards.first.id.should eq(@card2.id)
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card2.list_name)
      cards.first.start_date.should eq(@action3.date)
    end
  end

  context "receives a card from trello that has never existed in the Resumes to be Screened swimlane" do
    before do
      @board1.cards = [ @card2 ]
      @board1.lists = [ @list1, @list2 ]
      @board1.actions = [ ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the card's name, id, swimlane, and startdate into an array, telling the user the card hasn't been set up properly" do
      cards = CardService.all
      cards.first.name.should eq(@card2.name)
      cards.first.id.should eq(@card2.id)
      cards.count.should eq(1)
      cards.first.list_name.should eq(@card2.list_name)
      cards.first.start_date.should eq('This card has never been placed in the Resumes to be Screened lane.')
    end
  end

  context "receives multiple cards from trello that were created in the Resumes swimlane" do
    before do
      @board1.cards = [ @card1, @card2 ]
      @board1.lists = [ @list1, @list2 ]
      @board1.actions = [ @action1, @action3 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the cards' name, id, swimlane, and startdate into an array" do
      cards = CardService.all
      cards.first.name.should eq(@card1.name)
      cards.first.id.should eq(@card1.id)
      cards.first.list_name.should eq(@card1.list_name)
      cards.first.start_date.should eq(@action1.date)
      cards.last.name.should eq(@card2.name)
      cards.last.id.should eq(@card2.id)
      cards.last.list_name.should eq(@card2.list_name)
      cards.last.start_date.should eq(@action3.date)
      cards.count.should eq(2)
    end
  end

  context "receives multiple cards from trello that have multiple actions such as being both created and later moved into the Resumes swimlane" do
    before do
      @board1.cards = [ @card1, @card2 ]
      @board1.lists = [ @list1, @list2 ]
      @board1.actions = [ @action2later, @action2, @action3, @action4 ]
      @member.boards = [ @board1 ]
      Trello::Member.should_receive(:find).and_return(@member)
    end

    it "puts the cards' name, id, swimlane, and startdate into an array, using the latest movement into the Resumes swimlane as the start date" do
      cards = CardService.all
      cards.first.name.should eq(@card1.name)
      cards.first.id.should eq(@card1.id)
      cards.first.list_name.should eq(@card1.list_name)
      cards.first.start_date.should eq(@action2later.date)
      cards.last.name.should eq(@card2.name)
      cards.last.id.should eq(@card2.id)
      cards.last.list_name.should eq(@card2.list_name)
      cards.last.start_date.should eq(@action3.date)
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