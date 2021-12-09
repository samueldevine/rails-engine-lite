class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_one(query)
    where('name ILIKE ?', "%#{query}%")
      .order(:name)
      .first
  end
end
