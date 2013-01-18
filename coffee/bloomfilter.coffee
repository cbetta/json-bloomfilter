JsonBloomfilter =
  bits: null
  options:
    size: 100,
    hashes: 4,
    seed: (new Date().getTime() / 1000),
    bits: null

  new: (options = {}) ->
    @options[key] = value for key, value of options
    @bits = @BitArray.new(@options["size"], @options["bits"])
    this

  add: (key) ->
    @bits.add(index) for index in @indexesFor(key)
    return

  test: (key) ->
    for index in @indexesFor(key)
      return false if @bits.get(index) == 0
    true

  clear: ->
    @bits = @BitArray.new(@options["size"], null)
    return

  toHash: ->
    hash = {}
    hash[key] = value for key, value of @options
    hash["bits"] = @bits.field
    hash

  toJson: ->
    JSON.stringify @toHash()

  indexesFor: (key) ->
    indexes = []
    for index in [0..@options["hashes"]-1]
      indexes.push (@Zlib.crc32("#{key}:#{index+@options["seed"]}") % @options["size"])
    indexes
