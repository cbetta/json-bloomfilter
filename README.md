# JSON Bloomfilter

A BloomFilter implementation that is serialisable to JSON and compatible between both Ruby and Javascript. Very useful when needing to train a bloom filter in one language and using it in the other.

## Usage

### Installation

`gem install json-bloomfilter`

or

`gem 'json-bloomfilter'` in your Gemfile

### Ruby

```ruby
# create a new BloomFilter and add entries
filter = JsonBloomFilter.new size: 100
filter.add "foo"
filter.add "bar"
filter.test "foo" #=> true
filter.test "bar" #=> true
filter.test "doh" #=> probably false

# export the filter to a hash or json
config = filter.to_hash #=> { "size" => 100, "hashes" => 4, "seed" => 1234567890, "bits" => [...] }

# use the hash to generate a new BloomFilter with the same config
filter2 = BloomFilter.new config
filter2.test "foo" #=> true
filter2.test "bar" #=> true
filter2.test "doh" #=> probably false
```

Valid options for constructor are:

* `size` the number of items intended to store in the
* `hashes` the number of hashes used to calculate the bit positions in the bit field
* `seed` the seed for the hashing method

Additionally you can pass along:

* `bits` an array with the bitfield in non-bit format. Use `#to_hash` to create these for your active BloomFilter.

## Credits

* bitarray.rb and bitarray.coffee based on [version by Peter Cooper](https://github.com/peterc/bitarray).
* bloomfilter.rb and bloomfilter.coffee inspired by [Ilya Grigorik's Redis Bloomfilter](https://github.com/igrigorik/bloomfilter-rb/blob/master/lib/bloomfilter/redis.rb)
* zlib.coffee crc32 method based on the [node-crc32](https://github.com/mikepulaski/node-crc32) library and [this snippet](http://stackoverflow.com/questions/6226189/how-to-convert-a-string-to-bytearray/10132540#10132540)

## Release notes

* **0.0.4** Added JS tests
* **0.0.3** Added Ruby tests
* **0.0.2** First implementation of both Ruby and JS filters
* **0.0.1** Skeleton

## License

See LICENSE

