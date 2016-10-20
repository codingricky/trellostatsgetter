require 'trello'

class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date
  attr_reader :end_date

  TYPE_UPDATE = 'updateCard'
  TYPE_CREATE = 'createCard'
  STARTING_LANE = 'Resumes to be Screened'
  FINISHING_LANES = ['Success - Hired', 'Unsuccessful - Candidate Withdrew', 'Unsuccessful - Interview', 'Unsuccessful - Resume Screen']

  def initialize(list_id_to_name, name, id, list_id, actions)
    Rails.logger.info("creating card with id #{id}")
    @name = name
    @id = id
    @list_id = list_id
    @list_name = list_id_to_name[@list_id]
    Rails.logger.info("finding start date #{id}")
    @start_date = find_start_date(actions)
    Rails.logger.info("finished finding start date #{id}")

    if @start_date == 'Error'
      @end_date = 'Error'
    else
      Rails.logger.info("finding end date #{id}")
      @end_date = find_end_date(actions)
      Rails.logger.info("finished finding end date #{id}")

    end
  rescue
    @list_name = 'Error'
    @start_date = 'Error'
    @end_date = 'Error'
  end

  private
  def find_start_date(actions)
    if actions.nil?
      return nil
    else
      selected_action = find_create_action_in_starting_lane(actions)
      selected_action ||= find_update_action_with_destination_of_starting_lane(actions)
      selected_action ? selected_action.date : nil
    end
  rescue Exception => e
    return 'Error'
  end

  def find_create_action_in_starting_lane(actions)
    matching_action = nil
    incrementing_value = 0
    while incrementing_value < actions.count
      if !matching_action && is_create_action_in_starting_lane?(actions[incrementing_value])
        matching_action = actions[incrementing_value]
      end
      incrementing_value = incrementing_value + 1
    end
    selected_action = nil
    if matching_action
      selected_action = matching_action.data['list']['name'] == STARTING_LANE ? matching_action : nil
    end
    selected_action
  end

  def is_create_action_in_starting_lane?(action)
    (action.type == TYPE_CREATE) && (action.data['list']['name'].present?) && (action.data['card']['id'] == @id)
  end

  def find_update_action_with_destination_of_starting_lane(actions)
    selected_action = nil
    incrementing_value = 0
    while incrementing_value < actions.count
      if !selected_action && did_update_action_end_in_starting_lane?(actions[incrementing_value])
        selected_action = actions[incrementing_value]
      end
      incrementing_value = incrementing_value + 1
    end
    selected_action
  end

  def did_update_action_end_in_starting_lane?(action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == @id)
  end

  def find_end_date(actions)
    if actions.nil?
      return nil
    end

    if @list_name.in?(FINISHING_LANES)
      selected_action = nil
      incrementing_value = 0
      while incrementing_value < actions.count
        if !selected_action && did_update_action_end_in_finishing_lane?(actions[incrementing_value])
          selected_action = actions[incrementing_value]
        end
        incrementing_value = incrementing_value + 1
      end
    end
    selected_action ? selected_action.date : nil
  end

  def did_update_action_end_in_finishing_lane?(action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == @id)
  end

end