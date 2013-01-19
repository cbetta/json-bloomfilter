JsonBloomfilter = (options = {}) ->
  @options =
    size: 100,
    hashes: 4,
    seed: (new Date().getTime() / 1000),
    bits: null

  @options[key] = value for key, value of options
  @bits = new JsonBloomfilter.BitArray(@options["size"], @options["bits"])
  this

JsonBloomfilter.prototype.add = (key) ->
  @bits.add(index) for index in @indexesFor(key)
  return

JsonBloomfilter.prototype.test = (key) ->
  for index in @indexesFor(key)
    return false if @bits.get(index) == 0
  true

JsonBloomfilter.prototype.clear = ->
  @bits = new JsonBloomfilter.BitArray(@options["size"])
  return

JsonBloomfilter.prototype.toHash = ->
  hash = {}
  hash[key] = value for key, value of @options
  hash["bits"] = @bits.field
  hash

JsonBloomfilter.prototype.toJson = ->
  JSON.stringify @toHash()

JsonBloomfilter.prototype.indexesFor = (key) ->
  indexes = []
  for index in [0..@options["hashes"]-1]
    indexes.push (JsonBloomfilter.Zlib.crc32("#{key}:#{index+@options["seed"]}") % @options["size"])
  indexes