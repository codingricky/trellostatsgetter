namespace :downloadcards do
  desc "Updates db with cards from Trello"
  task get_cards_from_trello: :environment do
    DownloadedCardService.download_cards
  end
end