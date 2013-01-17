class BitArray
  attr_reader :size
  attr_reader :field
  include Enumerable

  ELEMENT_WIDTH = 32

  def initialize(size, field = nil)
    @size = size
    @field = field || Array.new(((size - 1) / ELEMENT_WIDTH) + 1, 0)
  end

  # Set a bit (1/0)
  def []=(position, value)
    if value == 1
      @field[position / ELEMENT_WIDTH] |= 1 << (position % ELEMENT_WIDTH)
    elsif (@field[position / ELEMENT_WIDTH]) & (1 << (position % ELEMENT_WIDTH)) != 0
      @field[position / ELEMENT_WIDTH] ^= 1 << (position % ELEMENT_WIDTH)
    end
  end

  # Read a bit (1/0)
  def [](position)
    @field[position / ELEMENT_WIDTH] & 1 << (position % ELEMENT_WIDTH) > 0 ? 1 : 0
  end

  # Iterate over each bit
  def each(&block)
    @size.times { |position| yield self[position] }
  end

  # Returns the field as a string like "0101010100111100," etc.
  def to_s
    inject("") { |a, b| a + b.to_s }
  end

  # Returns the total number of bits that are set
  # (The technique used here is about 6 times faster than using each or inject direct on the bitfield)
  def total_set
    @field.inject(0) { |a, byte| a += byte & 1 and byte >>= 1 until byte == 0; a }
  end
end