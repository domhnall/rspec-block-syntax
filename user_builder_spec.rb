require "./user_builder"

RSpec.describe UserBuilder do
  before :each do
    @dummy_client = double("api client", {
      create: "Done",
      get_token: "90809080"
    })

    @params = {
      api_client: @dummy_client,
      name: "Apollo Creed",
      shoe_size: 11
    }
  end

  describe "instantiation" do
    it "should be successful when all required arguements are supplied" do
      expect{
        UserBuilder.new(@params)
      }.not_to raise_error
    end

    it "should raise and error when the :api_client is not specified" do
      expect{
        @params.delete(:api_client)
        UserBuilder.new(@delete)
      }.to raise_error ArgumentError
    end

    it "should raise and error when :shoe_size is too small" do
      expect{
        UserBuilder.new(@params.merge(shoe_size: 1.5))
      }.to raise_error ArgumentError
    end

    it "should raise and error when :shoe_size is too small" do
      expect{
        UserBuilder.new(@params.merge(shoe_size: 21.5))
      }.to raise_error ArgumentError
    end

    it "should assign the name and shoe-size supplied" do
      builder = UserBuilder.new(@params)
      expect(builder.name).to eq @params[:name]
      expect(builder.shoe_size).to eq @params[:shoe_size]
    end

    it "should default the name to 'None' when not supplied" do
      @params.delete(:name)
      expect(UserBuilder.new(@params).name).to eq "None"
    end

    it "should default the shoe size to 10 when not supplied" do
      @params.delete(:shoe_size)
      expect(UserBuilder.new(@params).shoe_size).to eq 10
    end

    it "should default the south_paw flag to false when not supplied" do
      @params.delete(:south_paw)
      expect(UserBuilder.new(@params).south_paw).to be_falsey
    end
  end

  describe "instance method" do
    before :each do
      @builder = UserBuilder.new(@params)
    end

    describe "#build" do
      it "should call the API client" do
        expect(@dummy_client).to receive(:create)
        @builder.build
      end

      describe "API client call" do
        it "should set headers appropriately" do
          expect(@dummy_client).to receive(:create) do |headers, _body|
            expect(headers["Content-Type"]).to eq "application/json"
            expect(headers["Authorization"]).to eq "Bearer 90809080"
          end
          @builder.build
        end

        it "should set the body appropriately" do
          expect(@dummy_client).to receive(:create) do |_headers, body|
            expect(body[:name]).to eq "apollo creed"
            expect(body[:shoe_size]).to eq 11.5
          end
          @builder.build
        end
      end
    end
  end
end
