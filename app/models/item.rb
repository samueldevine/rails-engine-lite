class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0.0 }

  def self.find_all_by_name(query)
    where('name ILIKE ?', "%#{query}%")
      .order(:name)
  end
end
