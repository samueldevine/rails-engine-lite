require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'index' do
    describe 'happy path' do
      it 'returns a JSON object containing all merchants' do
        create_list(:merchant, 3)

        get '/api/v1/merchants'

        expect(response.status).to eq 200

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants).to have_key :data
        expect(merchants[:data].count).to eq 3

        merchants[:data].each do |merchant|
          expect(merchant).to have_key :id
          expect(merchant[:id]).to be_a String

          expect(merchant[:attributes]).to have_key :name
          expect(merchant[:attributes][:name]).to be_a String
        end
      end
    end

    # describe 'sad path' do
    #   it 'returns a JSON object with nil values' do
    #     get '/api/v1/merchants'

    #     expect(response.status).to eq 404

    #     merchants = JSON.parse(response.body, symbolize_names: true)

    #     expect(merchants.count).to eq 0

    #     expect(merchants.first).to have_key :id
    #     expect(merchants.first[:id]).to be_nil

    #     expect(merchants.first).to have_key :name
    #     expect(merchants.first[:name]).to be_nil
    #   end
    # end
  end

  describe 'show' do
    describe 'happy path' do
      it 'returns a single merchant' do
        id = create(:merchant).id
        get "/api/v1/merchants/#{id}"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(merchant).to have_key :data

        expect(merchant[:data]).to have_key :id
        expect(merchant[:data][:id]).to eq (id.to_s)

        expect(merchant[:data][:attributes]).to have_key :name
        expect(merchant[:data][:attributes][:name]).to be_a String
      end
    end

    describe 'sad path' do
    end
  end

  describe "merchant's items" do
    describe 'happy path' do
      it "returns all of a single merchant's items" do
        id = merchant_with_items.id
        get "/api/v1/merchants/#{id}/items"
        items = JSON.parse(response.body, symbolize_names: true)
        # binding.pry

        expect(response.status).to eq 200
        expect(items).to have_key :data

        items[:data].each do |item|
          expect(item).to have_key :id
          expect(item[:id]).to be_an String

          expect(item).to have_key :attributes

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
end
