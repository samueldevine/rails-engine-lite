require 'rails_helper'

RSpec.describe Merchant do
  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    describe '::find_one' do
      it 'returns a single merchant' do
        merchant = Merchant.create!(name: 'Jeff Bezos')
        result = Merchant.find_one('Bezos')

        expect(result).to be_a Merchant
        expect(result.name).to eq merchant.name
      end

      it 'returns the first alphabetical merchant if there are multiple matches' do
        merchant_1 = Merchant.create!(name: 'Jeff Bezos')
        merchant_2 = Merchant.create!(name: 'Jaf Bezos')
        result = Merchant.find_one('Bezos')

        expect(result).to be_a Merchant
        expect(result.name).to eq merchant_2.name
      end
    end
  end
end
