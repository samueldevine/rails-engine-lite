class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices

  validates :name, presence: true

  def self.find_one(query)
    where('name ILIKE ?', "%#{query}%")
      .order(:name)
      .first
  end
end
