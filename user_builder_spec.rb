require "./user_builder"

RSpec.describe UserBuilder do
  describe "instantiation" do
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

    it "should be successful when all required arguements are supplied" do
      expect{
        UserBuilder.new(@params)
      }.not_to raise_error
    end

    it "should raise and error when the :api_client is not specified" do
      expect{
        UserBuilder.new(@params.except(:api_client))
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
      expect(UserBuilder.new(@params.except(:name))).to eq "None"
    end

    it "should default the shoe size to 10 when not supplied" do
      expect(UserBuilder.new(@params.except(:shoe_size))).to eq 10
    end

    it "should default the south_paw flag to false when not supplied" do
      expect(UserBuilder.new(@params.except(:south_paw))).to be_falsey
    end
  end

  describe "instance method" do
    before :each do
      @builder = UserBuilder.new(@params)
    end

    describe "#build" do
      it "should call the API client" do
        expect(@dummy_client).to_receive(:create).and_return("Done")
        @builder.build
      end

      describe "API client call" do
        it "should have Content-Type appropriately set" do
          expect(@dummy_client).to_receive(:create) do |headers, _body|
            expect(headers["Content-Type"]).to eq "application/json"
          end.and_return("Done")
          @builder.build
        end
      end
    end
  end
end
