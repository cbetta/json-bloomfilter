# Serialisable (JSON) Bloom Filter

[![Build Status](https://travis-ci.org/cbetta/json-bloomfilter.png?branch=master)](https://travis-ci.org/cbetta/json-bloomfilter) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/cbetta/json-bloomfilter)

A bloom filter implementation that is serialisable to JSON and compatible between both Ruby and Javascript. Very useful when needing to train a bloom filter in one language and using it in the other.

## Why?

Bloom filters allow for space efficient lookups in a list, without having to store all the items in the list. This is useful for looking up tags, domain names, links, or anything else that you might want to do client side.

What this Gem allows you to do is build a bloom filter server side, add all your entries to it, and then serialise the filter to JSON. On the client side you can then load up the serialised data into the Javascript version and use the bloom filter as is.

All of this while not sending the entire list to the client, which is something you might not want to do for either security or efficiency reasons.

## Installation

### Ruby

```
gem install json-bloomfilter
```

### Javascript

With the gem installed run

```
json-bloomfilter install
```

and the `json-bloomfilter.min.js` will be copied to your local directory. If you are in a Rails project it will be copied to your `app/assets/javascripts` folder.

## Usage

### Ruby

```ruby
require "json/bloomfilter"

# use the factory to configure the filter
filter =  JsonBloomFilter.build 10000, 0.01 # number of expected items, desired error rate

# or create a define the BloomFilter manually
filter = JsonBloomFilter.new size: 100

# and add entries
filter.add "foo"
filter.add "bar"
# alternatively
filter.add ["foo", "bar"]
# test the entries
filter.test "foo" #=> true
filter.test "bar" #=> true
filter.test "doh" #=> probably false

# export the filter to a hash or json
filter.to_json #=> hash as JSON
config = filter.to_hash #=> { "size" => 100, "hashes" => 4, "seed" => 1234567890, "bits" => [...] }

# use the hash to generate a new filter with the same config
filter2 = JsonBloomFilter.new config
filter2.test "foo" #=> true
filter2.test "bar" #=> true
filter2.test "doh" #=> probably false
```

### Javascript

```javascript
// use the factory to configure the filter
filter =  JsonBloomFilter.build(10000, 0.01); // number of expected items, desired error rate

// or create a define the filter manually
filter = new JsonBloomFilter({ size: 100 });

// and add entries
filter.add("foo");
filter.add("bar");
// alternatively
filter.add(["foo", "bar"]);
// test the entries
filter.test("foo"); //=> true
filter.test("bar"); //=> true
filter.test("doh"); //=> probably false

// export the filter to a hash or json
filter.toJson();  //=> hash as JSON
config = filter.toHash(); //=> { "size" => 100, "hashes" => 4, "seed" => 1234567890, "bits" => [...] }

// use the hash to generate a new BloomFilter with the same config
filter2 = new JsonBloomFilter(config);
filter2.test("foo"); //=> true
filter2.test("bar"); //=> true
filter2.test("doh") //=> probably false
```

### Options

Valid options for constructor are:

* `size` (default: 100), the bit size of the bit array used
* `hashes` (default: 4), the number of hashes used to calculate the bit positions in the bit field
* `seed` (default: current UNIX time), the seed for the hashing method

Additionally you can pass along:

* `bits` (default: null), an array with the bitfield in non-bit format. Use `#to_hash` to create these for your active BloomFilter.

## Credits

* [bitarray.rb](https://github.com/cbetta/json-bloomfilter/blob/master/lib/json/bloomfilter/bitarray.rb) and [bitarray.coffee](https://github.com/cbetta/json-bloomfilter/blob/master/coffee/bitarray.coffee) based on [version by Peter Cooper](https://github.com/peterc/bitarray).
* [bloomfilter.rb](https://github.com/cbetta/json-bloomfilter/blob/master/lib/json/bloomfilter.rb) and [bloomfilter.coffee](https://github.com/cbetta/json-bloomfilter/blob/master/coffee/bloomfilter.coffee) inspired by [Ilya Grigorik's Redis Bloomfilter](https://github.com/igrigorik/bloomfilter-rb/blob/master/lib/bloomfilter/redis.rb)
* [zlib.coffee](https://github.com/cbetta/json-bloomfilter/blob/master/coffee/zlib.coffee) crc32 method based on the [node-crc32](https://github.com/mikepulaski/node-crc32) library and [this snippet](http://stackoverflow.com/questions/6226189/how-to-convert-a-string-to-bytearray/10132540#10132540)

## Compatibilities

### Confirmed:

* Ruby 1.8.7
* Ruby 1.8.2
* Ruby 1.9.3
* Rubinius (1.8 mode)
* Rubinius (1.9 mode)
* REE

### Probably will work:

* jRuby

## Release notes

* **0.1.4** Changed .build function to take a list of items
* **0.1.3** Adds a check for non positive capacity values on build
* **0.1.2** Adds Zlib dependency
* **0.1.1** Fixes a JS integer overflow issue and makes Ruby 1.8.7 compatible
* **0.1.0** Adds travis-ci. Bumped minor release version
* **0.0.6** Adds a factory that takes a size + error rate
* **0.0.5** Adds installer of JS file
* **0.0.4** Adds JS tests
* **0.0.3** Adds Ruby tests
* **0.0.2** Adds implementation of Ruby and JS filters
* **0.0.1** Gem skeleton

## License

See [LICENSE](https://github.com/cbetta/json-bloomfilter/blob/master/LICENSE)

