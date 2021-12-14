class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  def self.total_revenue(start_date, end_date)
    Invoice.joins(:transactions, :invoice_items)
      .where(invoices: {status: 'shipped'}, transactions: {result: 'success'})
      .where(invoices: {created_at: start_date..end_date})
      .select('SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
  end
end
