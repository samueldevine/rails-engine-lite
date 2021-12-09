require 'rails_helper'

RSpec.describe 'Merchant search' do
  describe 'find one' do
    describe 'happy path' do
      it 'returns a single merchant that matches the search result' do
        merchant = Merchant.create!(name: 'Denver Pizza Co.')

        query = 'pizza'
        get "/api/v1/merchants/find?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data][:attributes][:name]).to eq (merchant[:name]).to_s
      end

      it 'returns the first merchant alphabetically if there are multiple matches' do
        ph = Merchant.create!(name: 'Pizza Hut')
        dpc = Merchant.create!(name: 'Denver Pizza Co.')

        query = 'pizza'
        get "/api/v1/merchants/find?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data][:attributes][:name]).to eq (dpc[:name]).to_s
      end
    end

    describe 'sad path' do
      it 'returns an empty object if no merchants can be found' do
        ph = Merchant.create!(name: 'Pizza Hut')
        dpc = Merchant.create!(name: 'Denver Pizza Co.')

        query = 'noodles'
        get "/api/v1/merchants/find?name=#{query}"
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(result).to have_key :data
        expect(result[:data]).to eq({})
      end

      it 'returns 400 if no params are given' do
        get '/api/v1/merchants/find'
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 400
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq 'No params given'
      end

      it 'returns 400 if there are empty params' do
        get '/api/v1/merchants/find?name='
        result = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 400
        expect(result).to have_key :errors
        expect(result[:errors][:details]).to eq 'Search params cannot be empty'
      end
    end
  end
end
