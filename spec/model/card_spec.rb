require 'rspec'
require 'spec_helper'
require 'trello'

#consider using 'let'

describe Card do
  context "Trello api returns data with one card" do
    before do
      @list_name = 'Success - Hired'
      @action_date = '1/1/1991'
      @action_date_finish = '1/1/1992'
      @card_name = 'Bob'
      @card = SpecsHelper.create_one_card(@list_name, @action_date, @action_date_finish, @card_name)
    end

    it "gets the card's name" do
      @card.name.should eq(@card_name)
    end

    it "gets the card's list name" do
      @card.list_name.should eq(@list_name)
    end

    it "gets the card's start date" do
      @card.start_date.should eq(@action_date)
    end

    it "gets the card's end date" do
      @card.end_date.should eq(@action_date_finish)
    end
  end

  context "Trello api returns data with three lists" do
    before do
      @list_name = 'The right list'
      @card = SpecsHelper.create_a_card_multiple_lists(@list_name)
    end

    it "finds the right list" do
      @card.list_name.should eq(@list_name)
    end
  end

  context "Trello api returns data with multiple updateCard actions" do
    before do
      @action_date = '1/1/2001'
      @card = SpecsHelper.create_a_card_multiple_actions(@action_date)
    end

    it "finds the right action and gets the card's start date" do
      @card.start_date.should eq(@action_date)
    end
  end
end