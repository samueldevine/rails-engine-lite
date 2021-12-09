require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'index' do
    describe 'happy path' do
      it 'returns a JSON object containing all items' do
        create_list(:item, 3)
        get '/api/v1/items'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(items).to have_key :data
        expect(items[:data].count).to eq 3

        items[:data].each do |item|
          expect(item[:id]).to be_a String
          expect(item[:attributes][:name]).to be_a String
          expect(item[:attributes][:description]).to be_a String
          expect(item[:attributes][:unit_price]).to be_a Float
          expect(item[:attributes][:merchant_id]).to be_an Integer
        end
      end
    end

    describe 'sad path' do
      it 'returns an empty array if no items are found' do
        get '/api/v1/items'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(items).to have_key :data
        expect(items[:data]).to be_empty
      end
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

        expect(data[:id]).to be_a String
        expect(data[:attributes][:name]).to be_a String
        expect(data[:attributes][:description]).to be_a String
        expect(data[:attributes][:unit_price]).to be_a Float
        expect(data[:attributes][:merchant_id]).to be_an Integer
      end
    end

    describe 'sad path' do
    end
  end

  describe 'create' do
    describe 'happy path' do
      it 'returns the created item' do
        merchant_id = create(:merchant).id
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0',
          merchant_id: merchant_id
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        created_item = Item.last

        expect(response.status).to eq 201
        expect(created_item.name).to eq item_params[:name]
        expect(created_item.description).to eq item_params[:description]
        expect(created_item.unit_price).to eq item_params[:unit_price].to_f
        expect(created_item.merchant_id).to eq merchant_id
      end
    end

    describe 'sad path' do
      it 'returns an error if any attributes are missing' do
        merchant_id = create(:merchant).id
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          merchant_id: merchant_id
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

        expect(response.status).to eq 400
      end

      it 'ignores attributes that are not allowed' do
        merchant_id = create(:merchant).id
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0',
          merchant_id: merchant_id,
          evil_hacker_params: 'l33t_h4ck3r_c0d3 u got pwned!!!!'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 201
        expect(body[:data][:attributes]).to_not have_key :evil_hacker_params
      end
    end
  end

  describe 'update' do
    describe 'happy path' do
      it 'returns the updated item' do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
        updated_item = Item.find_by(id: id)

        expect(response.status).to eq 200
        expect(updated_item.name).to_not eq previous_name
        expect(updated_item.name).to eq 'Key'
        expect(updated_item.description).to eq item_params[:description]
        expect(updated_item.unit_price).to eq item_params[:unit_price].to_f
      end
    end

    describe 'sad path' do
      it 'returns the item if no updates are made' do
        item = create(:item)
        previous_name = item.name
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate(item: { name: item.name })

        expect(response.status).to eq 200
        expect(Item.find(item.id).name).to eq previous_name
      end

      it 'ignores attributes that are not allowed' do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0',
          evil_hacker_params: 'l33t_h4ck3r_c0d3 u got pwned!!!!'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(body[:data][:attributes]).to_not have_key :evil_hacker_params
      end

      it 'returns 404 if the item cannot be found' do
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0',
          evil_hacker_params: 'l33t_h4ck3r_c0d3 u got pwned!!!!'
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch '/api/v1/items/89012458942389045', headers: headers, params: JSON.generate(item: item_params)

        expect(response.status).to eq 404
      end

      it 'returns 400 if the merchant id is bad' do
        id = create(:item).id
        previous_name = Item.last.name
        item_params = {
          name: 'Key',
          description: 'Use this to open a door',
          unit_price: '100.0',
          merchant_id: 20_938_457_123_048_957
        }
        headers = { 'CONTENT_TYPE' => 'application/json' }
        patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

        expect(response.status).to eq 400
      end
    end
  end

  describe 'delete' do
    describe 'happy path' do
      it 'returns the deleted item' do
        id = create(:item).id

        expect(Item.count).to eq 1

        delete "/api/v1/items/#{id}"

        expect(response.status).to eq 204
        expect(response.body).to eq ''
      end
    end

    describe 'sad path'
  end

  describe "item's merchant" do
    describe 'happy path' do
      it 'returns the merchant associated with an item' do
        id = create(:item).id
        get "/api/v1/items/#{id}/merchant"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq 200
        expect(merchant).to have_key :data
        expect(merchant[:data]).to have_key :attributes

        expect(merchant[:data][:attributes][:name]).to be_a String
      end
    end

    describe 'sad path' do
      it 'returns 404 if the item is not found' do
        get '/api/v1/items/890123458937217456/merchant'

        expect(response.status).to eq 404
      end
    end
  end
end
