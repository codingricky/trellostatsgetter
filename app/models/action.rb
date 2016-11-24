class Action
  attr_reader :type
  attr_reader :data
  attr_reader :date

  def initialize(type, card_id, date)
    @type = type

    if @type == 'updateCard_finish'
      @type = 'updateCard'
    end

    if @type == 'updateCard_finish_old'
      @type = 'updateCard'
    end

    if @type == 'movedCard'
      @type = 'updateCard'
    end

    if type == 'copyCard'
      @data = {'list' =>{'name' => ConfigService.starting_lanes.first},
               'card' =>
                   {'id' =>card_id}}
    end

    if type == 'createCard'
      @data = {'list' =>{'name' => ConfigService.starting_lanes.first},
               'card' =>
                   {'id' =>card_id}}
    end

    if type == 'movedCard'
      @data = {'card' =>
                   {'id' =>card_id}}
    end

    if type == 'updateCard_finish'
      @data = {'listAfter' =>{'name' => ConfigService.finishing_lanes.first},
               'card' =>
           {'id' =>card_id}}
    end

    if type == 'updateCard_finish_old'
      @data = {'listAfter' =>{'name' => ConfigService.finishing_lanes.first},
               'card' =>
                   {'id' =>card_id}}
    end

    if type == 'updateCard'
      @data = {'listAfter' =>{'name' => ConfigService.starting_lanes.first},
               'card' =>
                   {'id' =>card_id}}
    end

    if type == 'addAttachmentToCard'
      @data = {'attachment' =>{'name' => 'Resume_Valid Source.pdf'},
               'card' =>
                   {'id' =>card_id}}
    end

    @date = date
  end
end