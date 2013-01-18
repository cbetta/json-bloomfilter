require_relative "bloomfilter/bitarray"
require "json"

class JsonBloomfilter
  DEFAULTS = { "size" => 100, "hashes" => 4, "seed" => Time.new.to_i, "bits" => nil }

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