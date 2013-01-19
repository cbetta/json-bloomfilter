require_relative "bloomfilter/bitarray"
require "json"

class JsonBloomfilter
  DEFAULTS = { "size" => 100, "hashes" => 4, "seed" => Time.new.to_i, "bits" => nil }

  def self.build capacity, error_rate
    size = (capacity * Math.log(error_rate) / Math.log(1.0 / 2**Math.log(2))).ceil
    hashes = (Math.log(2) * size / capacity).round
    JsonBloomfilter.new :size => size, :hashes => hashes
  end

  def initialize options = {}
    @options = merge_defaults_with options
    @bits = BitArray.new(@options["size"], @options["bits"])
  end

  def add key
    indexes_for(key).each { |index| @bits.add(index) }
    nil
  end

  def test key
    indexes_for(key).each do |index|
      return false if @bits.get(index) == 0
    end
    true
  end

  def clear
    @bits = BitArray.new(@options["size"])
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

  def merge_defaults_with options
    DEFAULTS.merge Hash[options.map {|k, v| ["#{k}", v] }]
  end
end