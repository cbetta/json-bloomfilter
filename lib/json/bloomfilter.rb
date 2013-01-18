require_relative "bitarray"
require "json"

class JsonBloomfilter
  DEFAULTS = { "size" => 100, "hashes" => 4, "seed" => Time.new.to_i, "bits" => nil }

  def initialize options = {}
    @options = DEFAULTS.merge options
    @bits = BitArray.new(@options["size"], @options["bits"])
  end

  def add key
    indexes_for(key).each { |index| @bits[index] = 1 }
    nil
  end

  def test key
    indexes_for(key).each do |index|
      return false if @bits[index] == 0
    end
    true
  end

  def clear
    @bits = BitArray.new(@options["size"], 0)
  end

  def to_hash
    @options.merge({ "bits" => @bits.field })
  end

  def to_json
    JSON.generate to_hash
  end

  private

  def indexes_for key
    Array.new(@options["hashes"]).each_with_index.map do |item, index|
      Zlib.crc32("#{key}:#{index+@options["seed"]}") % @options["size"]
    end
  end
end