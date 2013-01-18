JsonBloomfilter.BitArray = (size, field = null) ->
  @ELEMENT_WIDTH = 32
  @size = size
  @field = field || []

  arrayLength = Math.floor(((size - 1) / @ELEMENT_WIDTH) + 1)
  @field[i] = 0 for i in [0..arrayLength] unless field

  this

JsonBloomfilter.BitArray.prototype.add = (position) ->
  @set(position, 1)

JsonBloomfilter.BitArray.prototype.remove = (position) ->
  @set(position, 0)

JsonBloomfilter.BitArray.prototype.set = (position, value) ->
  aPos = @arrayPosition(position)
  bChange = @bitChange(position)
  if value == 1
    @field[aPos] |= bChange
  else if @field[aPos] & bChange != 0
    @field[aPos] ^= bChange
  true

JsonBloomfilter.BitArray.prototype.get = (position) ->
  aPos = @arrayPosition(position)
  bChange = @bitChange(position)
  if (@field[aPos] & bChange) > 0
    return 1
  else
    return 0

JsonBloomfilter.BitArray.prototype.arrayPosition = (position) ->
  Math.floor(position / @ELEMENT_WIDTH)

JsonBloomfilter.BitArray.prototype.bitChange = (position) ->
  Math.abs(1 << position % @ELEMENT_WIDTH)

JsonBloomfilter.BitArray.prototype.toString = ->
  output = ""
  output += @get(i) for i in [0..@size-1]
  output