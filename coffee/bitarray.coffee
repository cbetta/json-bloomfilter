JsonBloomfilter.BitArray = (size, field = null) ->
  throw new Error("Missing argument: size") unless size

  @ELEMENT_WIDTH = 32
  @size = size
  @field = field || []

  arrayLength = Math.floor(((size - 1) / @ELEMENT_WIDTH) + 1)
  @field[i] = 0 for i in [0..arrayLength-1] unless field

  this

JsonBloomfilter.BitArray.prototype.add = (position) ->
  @set(position, 1)

JsonBloomfilter.BitArray.prototype.remove = (position) ->
  @set(position, 0)

JsonBloomfilter.BitArray.prototype.set = (position, value) ->
  throw new Error("BitArray index out of bounds") if position >= @size
  aPos = @arrayPosition(position)
  bChange = @bitChange(position)
  if value == 1
    @field[aPos] = @abs(@field[aPos] | bChange)
  else if (@field[aPos] & bChange) != 0
    @field[aPos] = @abs(@field[aPos] ^ bChange)
  true

JsonBloomfilter.BitArray.prototype.get = (position) ->
  throw new Error("BitArray index out of bounds") if position >= @size
  aPos = @arrayPosition(position)
  bChange = @bitChange(position)
  if @abs(@field[aPos] & bChange) > 0
    return 1
  else
    return 0

JsonBloomfilter.BitArray.prototype.arrayPosition = (position) ->
  Math.floor(position / @ELEMENT_WIDTH)

JsonBloomfilter.BitArray.prototype.bitChange = (position) ->
  @abs(1 << position % @ELEMENT_WIDTH)

JsonBloomfilter.BitArray.prototype.abs = (val) ->
  val += 4294967295 if val < 0
  val

JsonBloomfilter.BitArray.prototype.toString = ->
  output = ""
  output += @get(i) for i in [0..@size-1]
  output