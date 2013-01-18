JsonBloomfilter.BitArray =
    size: null
    field: null

    ELEMENT_WIDTH: 32

    new: (size, field = null) ->
      @size = size
      arrayLength = Math.floor(((size - 1) / @ELEMENT_WIDTH) + 1)
      @field = field || []
      @field[i] = 0 for i in [0..arrayLength] unless field
      this

    add: (position) ->
      @set(position, 1)

    remove: (position) ->
      @set(position, 0)

    set: (position, value) ->
      aPos = @arrayPosition(position)
      bChange = @bitChange(position)
      if value == 1
        @field[aPos] |= bChange
      else if @field[aPos] & bChange != 0
        @field[aPos] ^= bChange
      true

    get: (position) ->
      aPos = @arrayPosition(position)
      bChange = @bitChange(position)
      if (@field[aPos] & bChange) > 0
        return 1
      else
        return 0

    arrayPosition: (position) ->
      Math.floor(position / @ELEMENT_WIDTH)

    bitChange: (position) ->
      Math.abs(1 << position % @ELEMENT_WIDTH)

    toString: ->
      output = ""
      output += @get(i) for i in [0..@size-1]
      output
