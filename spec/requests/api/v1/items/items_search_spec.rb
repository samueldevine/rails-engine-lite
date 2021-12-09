require 'rails_helper'

RSpec.describe 'Items search' do
  describe 'find all' do
    describe 'happy path' do
      describe 'name filter' do
        it 'returns an array of item objects that match a name query' do
          merchant = Merchant.create!(name: 'Kilton')
          item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
          item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
          item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')

          query = 'tunic'
          get "/api/v1/items/find_all?name=#{query}"
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq 200
          expect(result).to have_key :data
          expect(result[:data]).to be_an Array
          expect(result[:data].first[:attributes][:name]).to eq item_3.name
        end
      end

      describe 'price filter' do
        it 'returns an array of item objects above a minimum price filter' do
          merchant = Merchant.create!(name: 'Kilton')
          item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
          item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
          item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')

          query = '400'
          get "/api/v1/items/find_all?min_price=#{query}"
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq 200
          expect(result).to have_key :data
          expect(result[:data]).to be_an Array
          expect(result[:data].count).to eq 2
          expect(result[:data].first[:attributes][:name]).to eq item_3.name
        end

        it 'returns an array of item objects below a maximum price filter' do
          merchant = Merchant.create!(name: 'Kilton')
          item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
          item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
          item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')

          query = '400'
          get "/api/v1/items/find_all?max_price=#{query}"
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq 200
          expect(result).to have_key :data
          expect(result[:data]).to be_an Array
          expect(result[:data].count).to eq 1
          expect(result[:data].first[:attributes][:name]).to eq item_2.name
        end

        it 'returns an array of item objects between two price filters' do
          merchant = Merchant.create!(name: 'Kilton')
          item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')
          item_2 = merchant.items.create!(name: 'Kokiri Tunic', description: 'green', unit_price: '399.99')
          item_3 = merchant.items.create!(name: 'Goron Tunic', description: 'red', unit_price: '550.99')

          min = '500'
          max = '575'
          get "/api/v1/items/find_all?min_price=#{min}&max_price=#{max}"
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response.status).to eq 200
          expect(result).to have_key :data
          expect(result[:data]).to be_an Array
          expect(result[:data].count).to eq 1
          expect(result[:data].first[:attributes][:name]).to eq item_3.name
        end
      end
    end

    describe 'sad path' do
      it 'returns an empty array if there are no matches' do
        merchant = Merchant.create!(name: 'Kilton')
        item_1 = merchant.items.create!(name: 'Zora Tunic', description: 'blue', unit_price: '600')

        query = 'goron'
        get "/api/v1/items/find_all?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data]).to be_an Array
        expect(result[:data]).to be_empty
      end

      it 'returns 400 if no params are given' do
        get '/api/v1/items/find_all'
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 400
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq 'No params given'
      end

      it 'returns 400 if there are empty params' do
        get '/api/v1/items/find_all?name='
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 400
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq 'Search params cannot be empty'
      end

      it 'returns 400 if name and price params are both included' do
        get '/api/v1/items/find_all?name=jeff&min_price=5.00'
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 400
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq 'Cannot mix name and price search params'
      end
    end
  end
end
