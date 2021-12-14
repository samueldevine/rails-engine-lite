class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0.0 }

  def self.find_all_by_name(query)
    where('name ILIKE ?', "%#{query}%")
      .order(:name)
  end

  def self.find_all_price_above(min_price)
    where('unit_price > ?', min_price)
      .order(:name)
  end

  def self.find_all_price_below(max_price)
    where('unit_price < ?', max_price)
      .order(:name)
  end

  def self.find_all_price_between(min_price, max_price)
    where('unit_price > ?', min_price)
      .where('unit_price < ?', max_price)
      .order(:name)
  end
end
