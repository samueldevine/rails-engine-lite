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

  def self.top_merchants_by_revenue(number)
    Merchant
      .joins(invoices: [:transactions, :invoice_items])
      .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
      .group(:id)
      .select('SUM(invoice_items.unit_price * invoice_items.quantity) AS revenue, merchants.*')
      .order('revenue DESC')
      .limit(number)
  end
end
