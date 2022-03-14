require 'date'
require './user_builder'

dummy_client = Object.new.tap do |client|
  def client.get_token
    "90809080"
  end

  def client.create(*args)
    puts "Making API call with args: #{args}"
  end
end

builder = UserBuilder.new(
  api_client: dummy_client,
  name: "Rocky Balboa",
  shoe_size: 10.5,
  south_paw: true
)

builder.build
