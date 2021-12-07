require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'index' do
    describe 'happy path' do
      it 'returns a JSON object containing all items' do
        create_list(:item, 3)

        get '/api/v1/items'

        expect(response.status).to eq 200

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items).to have_key :data
        expect(items[:data].count).to eq 3

        items[:data].each do |item|
          expect(item).to have_key :id
          expect(item[:id]).to be_a String

          expect(item[:attributes]).to have_key :name
          expect(item[:attributes][:name]).to be_a String

          expect(item[:attributes]).to have_key :description
          expect(item[:attributes][:description]).to be_a String

          expect(item[:attributes]).to have_key :unit_price
          expect(item[:attributes][:unit_price]).to be_a Float

          expect(item[:attributes]).to have_key :merchant_id
          expect(item[:attributes][:merchant_id]).to be_an Integer
        end
      end
    end

    describe 'sad path' do
    end
  end

  describe 'show' do
    describe 'happy path' do
      it 'returns JSON for a single item' do
        id = create(:item).id
        get "/api/v1/items/#{id}"

        expect(response.status).to eq 200

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item).to have_key :data

        data = item[:data]

        expect(data).to have_key :attributes

        expect(data).to have_key :id
        expect(data[:id]).to be_a String

        expect(data[:attributes]).to have_key :name
        expect(data[:attributes][:name]).to be_a String

        expect(data[:attributes]).to have_key :description
        expect(data[:attributes][:description]).to be_a String

        expect(data[:attributes]).to have_key :unit_price
        expect(data[:attributes][:unit_price]).to be_a Float

        expect(data[:attributes]).to have_key :merchant_id
        expect(data[:attributes][:merchant_id]).to be_an Integer
      end
    end

    describe 'sad path' do
    end
  end

end
