class ItemSerializer
  include JSONAPI::Serializer

  attributes :name, :description, :unit_price, :merchant_id

  def self.no_params
    { errors: { details: 'No params given' } }
  end

  def self.empty_params
    { errors: { details: 'Search params cannot be empty' } }
  end

  def self.name_and_price_params
    { errors: { details: 'Cannot mix name and price search params' } }
  end
end
