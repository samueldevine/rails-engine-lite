class MerchantSerializer
  include JSONAPI::Serializer

  attributes :name

  def self.not_found
    { data: {}}
  end
end
