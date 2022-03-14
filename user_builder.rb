class UserBuilder
  attr_reader :api_client,
    :name,
    :shoe_size,
    :south_paw

  # The :api_client must expose two methods:
  # * :create method to create the User
  # * :get_token to return an Authorization token for the API call
  def initialize(api_client: nil,
                 name: "None",
                 shoe_size: 10,
                 south_paw: false)
    unless (3..16).include?(shoe_size)
      raise ArgumentError, ":shoe_size must be between 3-16"
    end
    @api_client = api_client
    @name = name
    @shoe_size = shoe_size
    @south_paw = south_paw
  end

  def build
    api_client.create({
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_client.get_token}"
    }, {
      name: name.downcase,
      shoe_size: convert_uk_to_us(shoe_size),
      south_paw: south_paw
    })
  end

  private

  def convert_uk_to_us(shoe_size)
    shoe_size + 0.5
  end
end
