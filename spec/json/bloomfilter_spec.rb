require "spec_helper"

describe JsonBloomfilter do

  describe "#initialize" do
    it "should take the appropriate options" do
      seed = Time.now.to_i - 24*60*60
      bf = JsonBloomfilter.new size: 200, hashes: 10, seed: seed
      expect(bf.to_hash["size"]).to be == 200
      expect(bf.to_hash["hashes"]).to be == 10
      expect(bf.to_hash["seed"]).to be == seed
    end

    it "should be initializable with a field serialized by another bloom filter" do
      bf1 = JsonBloomfilter.new
      bf1.add "foo"
      bf2 = JsonBloomfilter.new bf1.to_hash
      expect(bf2.test "foo").to be_true
    end
  end

  context "with an instance" do
    before :each do
      @bf = JsonBloomfilter.new
      @bf.add("foobar")
    end

    describe "#add, #test" do
      it "should add a key" do
        expect(@bf.test "foo").to be_false
        @bf.add "foo"
        expect(@bf.test "foo").to be_true
      end

      it "should not change anything if added twice" do
        expect(@bf.test "foobar").to be_true
        bits = @bf.to_hash["bits"]
        @bf.add "foobar"
        expect(@bf.test "foobar").to be_true
        expect(@bf.to_hash["bits"]).to be == bits
      end
    end

    describe "#clear" do
      it "should clear the bit array" do
        expect(@bf.to_hash["bits"]).not_to be == [0,0,0,0]
        @bf.clear
        expect(@bf.to_hash["bits"]).to be == [0,0,0,0]
      end
    end

    describe "#to_hash" do
      it "should return the serialisable hash" do
        hash = @bf.to_hash
        expect(hash).to be_a(Hash)

        expect(hash).to have_key("seed")
        expect(hash["seed"]).to be_a(Integer)

        expect(hash).to have_key("hashes")
        expect(hash["hashes"]).to be_a(Integer)

        expect(hash).to have_key("size")
        expect(hash["size"]).to be_a(Integer)

        expect(hash).to have_key("bits")
        expect(hash["bits"]).to be_a(Array)
      end
    end

    describe "#to_json" do
      it "should return the hash serialised" do
        expect(@bf.to_json).to be == JSON.generate(@bf.to_hash)
      end
    end

  end
end