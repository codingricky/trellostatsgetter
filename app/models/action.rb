class Action
  attr_reader :type
  attr_reader :data
  attr_reader :date

  def initialize(type, card_id, date)
    @type = type

    if @type == 'updateCard_finish'
      @type = 'updateCard'
    end

    if type == "createCard"
      @data = {"list"=>{"name"=>"Resumes to be Screened"},
               "card"=>
                   {"id"=>card_id}}
    end

    if type == "updateCard_finish"
      @data = {"listAfter"=>{"name"=>"Success - This is an end lane"},
       "card"=>
           {"id"=>card_id}}
    end

    if type == "updateCard"
      @data = {"listAfter"=>{"name"=>"Resumes to be Screened"},
               "card"=>
                   {"id"=>card_id}}
    end

    @date = date
  end
end