class Action
  attr_reader :type
  attr_reader :data
  attr_reader :date

  def initialize(type, card_id, date)
    @type = type

    if type == "createCard"
      @data = {"list"=>{"name"=>"Resumes to be Screened"},
               "card"=>
                   {"id"=>card_id}}
    else
      @data = {"listAfter"=>{"name"=>"Resumes to be Screened"},
               "card"=>
                   {"id"=>card_id}}
    end

      @date = date
    end
  end