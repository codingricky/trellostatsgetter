class Source < ApplicationRecord

  def matches?(value)
    matches = value.downcase.include?(self.name.downcase)
    return true if matches

    self.keywords.split(' ').each do |keyword|
      return true if value.downcase.include?(keyword)
    end

    false
  end
end
