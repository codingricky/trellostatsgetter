class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :start_date
  attr_reader :end_date

  def initialize(params = {})
    @name = params[:name]
    @id = params[:id]
    @list_id = params[:list_id]
    @list_name = params[:list_name]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def duration_in_days
    return nil if @start_date.nil?

    start_date = @start_date
    end_date = @end_date.nil? ? DateTime.now : @end_date
    (end_date.to_date - start_date.to_date).to_i
  end

end