JsonBloomfilter = (options = {}) ->
  @options =
    size: 100,
    hashes: 4,
    seed: (new Date().getTime() / 1000),
    bits: null

  items = delete options["items"]
  @options[key] = value for key, value of options
  @bits = new JsonBloomfilter.BitArray(@options["size"], @options["bits"])
  @add(items) if items
  this

JsonBloomfilter.build = (capacity_or_items, error_rate) ->
  capacity = JsonBloomfilter.capacity_for(capacity_or_items)
  items = JsonBloomfilter.items_for(capacity_or_items)
  throw new Error("Capacity needs to be a positive integer") if capacity <= 0
  new JsonBloomfilter({size: JsonBloomfilter.size_for(capacity, error_rate), hashes: JsonBloomfilter.hashes_for(capacity, error_rate), items: items})

JsonBloomfilter.capacity_for = (capacity_or_items) ->
  if capacity_or_items instanceof Array
    capacity_or_items.length
  else
    capacity_or_items

JsonBloomfilter.items_for = (capacity_or_items) ->
  if capacity_or_items instanceof Array
    capacity_or_items
  else
    null

JsonBloomfilter.size_for = (capacity, error_rate) ->
  Math.ceil(capacity * Math.log(error_rate) / Math.log(1.0 / Math.pow(2,Math.log(2))))

JsonBloomfilter.hashes_for = (capacity, error_rate) ->
  Math.round(Math.log(2) * @size_for(capacity, error_rate) / capacity)

JsonBloomfilter.prototype.add = (keys) ->
  for key in [].concat(keys)
    @bits.add(index) for index in @indexesFor(key)
  return

JsonBloomfilter.prototype.test = (keys) ->
  for key in [].concat(keys)
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