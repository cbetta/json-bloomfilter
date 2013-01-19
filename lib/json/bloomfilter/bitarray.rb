class JsonBloomfilter
  class BitArray
    attr_reader :size
    attr_reader :field
    include Enumerable

    ELEMENT_WIDTH = 32

    def initialize(size, field = nil)
      @size = size
      @field = field || Array.new(((size - 1) / ELEMENT_WIDTH) + 1, 0)
    end

    def add position
      self[position] = 1
    end

    def remove position
      self[position] = 0
    end

    # Set a bit (1/0)
    def []=(position, value)
      raise ArgumentError.new("Position out of bound (#{position} for max #{@size})") if position >= @size
      if value == 1
        @field[position / ELEMENT_WIDTH] |= 1 << (position % ELEMENT_WIDTH)
      elsif (@field[position / ELEMENT_WIDTH]) & (1 << (position % ELEMENT_WIDTH)) != 0
        @field[position / ELEMENT_WIDTH] ^= 1 << (position % ELEMENT_WIDTH)
      end
    end

    # Read a bit (1/0)
    def get position
      raise ArgumentError.new("Position out of bound (#{position} for max #{@size})") if position >= @size
      @field[position / ELEMENT_WIDTH] & 1 << (position % ELEMENT_WIDTH) > 0 ? 1 : 0
    end

    # Iterate over each bit
    def each(&block)
      @size.times { |position| yield self.get(position) }
    end

    # Returns the field as a string like "0101010100111100," etc.
    def to_s
      inject("") { |a, b| a + b.to_s }
    end
  end
end