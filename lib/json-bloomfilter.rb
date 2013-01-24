require "json-bloomfilter/bitarray"
require "json"
require "zlib"

class JsonBloomfilter
  DEFAULTS = { "size" => 100, "hashes" => 4, "seed" => Time.new.to_i, "bits" => nil }

  def self.build capacity_or_items, error_rate
    capacity, items = capacity_or_items.is_a?(Array) ? [capacity_or_items.length, capacity_or_items] : [capacity_or_items, nil]
    raise ArgumentError.new("Capacity needs to be a positive integer") if capacity <= 0
    JsonBloomfilter.new :size => size_for(capacity, error_rate), :hashes => hashes_for(capacity, error_rate), items: items
  end

  def self.size_for capacity, error_rate
    (capacity * Math.log(error_rate) / Math.log(1.0 / 2**Math.log(2))).ceil
  end

  def self.hashes_for capacity, error_rate
    (Math.log(2) * size_for(capacity, error_rate) / capacity).round
  end

  def initialize options = {}
    items = options.delete("items")
    @options = merge_defaults_with options
    @bits = BitArray.new(@options["size"], @options["bits"])
    add(items) if items
  end

  def add keys
    [keys].flatten.each do |key|
      indexes_for(key).each { |index| @bits.add(index) }
    end
    nil
  end

  def test keys
    [keys].flatten.each do |key|
      indexes_for(key).each do |index|
        return false if @bits.get(index) == 0
      end
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