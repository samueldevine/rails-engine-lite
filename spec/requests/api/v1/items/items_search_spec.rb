require 'rails_helper'

RSpec.describe 'Items search' do
  describe 'find all' do
    describe 'happy path' do
      it 'returns an array of item objects that match the search query' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
        item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
        item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')

        query = "tunic"
        get "/api/v1/items/find_all?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data]).to be_an Array
        expect(result[:data].first[:attributes][:name]).to eq item_3.name
      end
    end

    describe 'sad path' do
      it 'returns an empty array if there are no matches' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')

        query = "goron"
        get "/api/v1/items/find_all?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data]).to be_an Array
        expect(result[:data]).to be_empty
      end
    end
  end
end
