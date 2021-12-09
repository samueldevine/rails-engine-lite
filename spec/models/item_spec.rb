require 'rails_helper'

RSpec.describe Item do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0.0) }
  end

  describe 'class methods' do
    describe '::find_all_by_name' do
      it 'returns all items that match the name in alphabetical order' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
        item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
        item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')
        query = 'tunic'

        results = Item.find_all_by_name(query)

        expect(results).to be_an ActiveRecord::Relation
        expect(results.first.name).to eq item_3.name
        expect(results.last.name).to eq item_1.name
      end
    end

    describe '::find_all_price_above' do
      it 'returns all items above a minimum price' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
        item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
        item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')
        min = '400'

        results = Item.find_all_price_above(min)

        expect(results).to be_an ActiveRecord::Relation
        expect(results.count).to eq 2
        expect(results.first.name).to eq item_3.name
        expect(results.last.name).to eq item_1.name
      end
    end

    describe '::find_all_price_below' do
      it 'returns all items below a maximum price' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
        item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
        item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')
        max = '400'

        results = Item.find_all_price_below(max)

        expect(results).to be_an ActiveRecord::Relation
        expect(results.count).to eq 1
        expect(results.first.name).to eq item_2.name
      end
    end

    describe '::find_all_price_between' do
      it 'returns all items between a minimum and maximum price' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
        item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
        item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')
        min = '400'
        max = '575'

        results = Item.find_all_price_between(min, max)

        expect(results).to be_an ActiveRecord::Relation
        expect(results.count).to eq 1
        expect(results.first.name).to eq item_3.name
      end
    end
  end
end
