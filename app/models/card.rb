class Card
  attr_reader :id
  attr_reader :list_id
  attr_reader :name
  attr_reader :list_name
  attr_reader :url
  attr_reader :source
  attr_reader :attachments
  attr_accessor :start_date
  attr_accessor :end_date

  def initialize(params = {})
    @name = sanitized_name(params[:name])
    @id = params[:id]
    @list_id = params[:list_id]
    @list_name = params[:list_name]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @url = params[:url]
    @attachments = params[:attachments]
    @source = search_for_sources(params[:name], params[:attachments])
  end

  def duration_in_days
    return nil if @start_date.nil?

    start_date = @start_date
    end_date = @end_date.nil? ? DateTime.now : @end_date
    (end_date.to_date - start_date.to_date).to_i
  end

  def sanitized_name(name)
    name.gsub(/\$[-.,\w]*|\d\d\d[k,\d]*|\d\d[k,]/, '')
  end

  def find_matching_source(name)
    ConfigService.source_names.find {|source_name| name.downcase.match(source_name.downcase)}
  end

  def search_for_sources(card_name, attachment_names)
    source = find_matching_source(card_name)
    return source if source.present?

    if attachment_names.present?
      source = attachment_names.map {|attachment_name| find_matching_source(attachment_name)}.compact.first
    end
    source
  end

end