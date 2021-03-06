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
          expect(merchant[:id]).to be_a String
          expect(merchant[:attributes][:name]).to be_a String
        end
      end
    end

    describe 'sad path' do
      it 'returns an empty collection if no merchants exist' do
        get '/api/v1/merchants'

        expect(response.status).to eq 200
        expect(Merchant.count).to eq 0
      end
    end
  end

  describe 'show' do
    describe 'happy path' do
      it 'returns a single merchant' do
        id = create(:merchant).id
        get "/api/v1/merchants/#{id}"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(merchant).to have_key :data

        expect(merchant[:data][:id]).to eq(id.to_s)
        expect(merchant[:data][:attributes][:name]).to be_a String
      end
    end

    describe 'sad path' do
      it 'returns 404 if the merchant is not found' do
        get '/api/v1/merchants/1'
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 404
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq "Couldn't find Merchant with 'id'=1"
      end
    end
  end

  describe "merchant's items" do
    describe 'happy path' do
      it "returns all of a single merchant's items" do
        id = merchant_with_items.id
        get "/api/v1/merchants/#{id}/items"
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(items).to have_key :data

        items[:data].each do |item|
          expect(item[:id]).to be_an String
          expect(item).to have_key :attributes
          expect(item[:attributes][:name]).to be_a String
          expect(item[:attributes][:description]).to be_a String
          expect(item[:attributes][:unit_price]).to be_a Float
          expect(item[:attributes][:merchant_id]).to be_an Integer
        end
      end
    end

    describe 'sad path' do
      it 'returns 404 if the merchant is not found' do
        get '/api/v1/merchants/980234980589347257/items'

        expect(response.status).to eq 404
      end
    end
  end
end
