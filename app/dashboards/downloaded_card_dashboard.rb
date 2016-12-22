require "administrate/base_dashboard"

class DownloadedCardDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    sanitized_name: Field::String,
    card_id: Field::String,
    list_id: Field::String,
    list_name: Field::String,
    url: Field::String,
    start_date: Field::DateTime,
    end_date: Field::DateTime,
    location: Field::String,
    attachments: Field::String,
    source: Field::String,
    actions: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :sanitized_name,
    :card_id,
    :list_id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :sanitized_name,
    :card_id,
    :list_id,
    :list_name,
    :url,
    :start_date,
    :end_date,
    :location,
    :attachments,
    :source,
    :actions,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :sanitized_name,
    :card_id,
    :list_id,
    :list_name,
    :url,
    :start_date,
    :end_date,
    :location,
    :attachments,
    :source,
    :actions,
  ].freeze

  # Overwrite this method to customize how downloaded cards are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(downloaded_card)
  #   "DownloadedCard ##{downloaded_card.id}"
  # end
end
