require "spec_helper"

describe JsonBloomfilter::BitArray do

  describe "#initialize" do
    it "should require a size" do
      expect(->{JsonBloomfilter::BitArray.new}).to raise_error(ArgumentError)
      expect(->{JsonBloomfilter::BitArray.new(100)}).not_to raise_error(ArgumentError)
    end
    it "should take an optional bit field" do
      field = [0,0,0,2]
      ba = JsonBloomfilter::BitArray.new(100, field)
      expect(ba.field).to be == field
    end
  end

  describe "#add" do
    it "should set the bit to 1" do
      ba = JsonBloomfilter::BitArray.new(10)
      ba.add(9)
      expect(ba.to_s).to be == "0000000001"
    end

    it "should throw an error on out of bound" do
      ba = JsonBloomfilter::BitArray.new(10)
      expect(->{ba.add(10)}).to raise_error
    end
  end

  describe "#remove" do
    it "should set the bit to 0" do
      ba = JsonBloomfilter::BitArray.new(10)
      ba.add(9)
      ba.remove(9)
      expect(ba.to_s).to be == "0000000000"
    end

    it "should throw an error on out of bound" do
      ba = JsonBloomfilter::BitArray.new(10)
      expect(->{ba.remove(10)}).to raise_error
    end
  end

  describe "#get" do
    it "should return the bit set" do
      ba = JsonBloomfilter::BitArray.new(10)
      ba.add(9)
      expect(ba.get(9)).to be == 1
      expect(ba.get(8)).to be == 0
    end

    it "should throw an error on out of bound" do
      ba = JsonBloomfilter::BitArray.new(10)
      expect(->{ba.get(10)}).to raise_error
    end
  end

  describe "#to_s" do
    it "should output the bit string" do
      ba = JsonBloomfilter::BitArray.new(10)
      ba.add(3)
      ba.add(9)
      expect(ba.to_s).to be == "0001000001"
    end
  end
end