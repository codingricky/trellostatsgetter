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

    Rails.logger.info("finding end date #{id}")
    @end_date = find_end_date(actions)
    Rails.logger.info("finished finding end date #{id}")

  end

  def duration_in_days
    return nil if @start_date.nil?

    start_date = @start_date
    end_date = @end_date.nil? ? DateTime.now : @end_date
    (end_date.to_date - start_date.to_date).to_i
  end

  private
  def find_start_date(actions)
      selected_action = actions.find { |action| is_create_action_in_starting_lane?(action) }
      selected_action ||= actions.find { |action| did_update_action_end_in_starting_lane?(action) }
      selected_action.try(:date)
  end

  def is_create_action_in_starting_lane?(action)
    (action.type == TYPE_CREATE) &&
        action.data['list']['name'] == STARTING_LANE &&
        action.data['list']['name'].present? &&
        (action.data['card']['id'] == @id)
  end


  def did_update_action_end_in_starting_lane?(action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].include?(STARTING_LANE)) && (action.data['card']['id'] == @id)
  end

  def find_end_date(actions)
    if @list_name.in?(FINISHING_LANES)
      selected_action = actions.find { |action| did_update_action_end_in_finishing_lane?(action) }
    end
    selected_action.try(:date)
  end

  def did_update_action_end_in_finishing_lane?(action)
    (action.type == TYPE_UPDATE) && (action.data['listAfter']) && (action.data['listAfter']['name'].in?(FINISHING_LANES)) && (action.data['card']['id'] == @id)
  end

end