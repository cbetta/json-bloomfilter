describe("JsonBloomfilter", function() {

  describe(".build", function() {
    it("should generate a BloomFilter with the right number of hashes and size", function() {
      bf = JsonBloomfilter.build(1000, 0.01);
      expect(bf.toHash()["hashes"]).toBe(7);
      expect(bf.toHash()["size"]).toBe(9586);
    });

    it("should optionally take an array of strings instead of a capacity", function() {
      bf = JsonBloomfilter.build(["foo", "bar"], 0.01);
      expect(bf.toHash()["hashes"]).toBe(7);
      expect(bf.toHash()["size"]).toBe(20);
    });

    it("should require a positive integer capacity", function() {
      expect(function(){new JsonBloomfilter.build(0, 0.01)}).toThrow("Capacity needs to be a positive integer")
    });

  });

  describe("#initialize", function() {
    it("should take the appropriate options", function() {
      seed = (new Date().getTime()/1000) - 24*60*60;
      bf = new JsonBloomfilter({ size: 200, hashes: 10, seed: seed });
      expect(bf.toHash()["size"]).toBe(200);
      expect(bf.toHash()["hashes"]).toBe(10);
      expect(bf.toHash()["seed"]).toBe(seed);
    });

    it("should be initializable with a field serialized by another bloom filter", function() {
      bf1 = new JsonBloomfilter();
      bf1.add("foo");
      bf2 = new JsonBloomfilter(bf1.toHash());
      expect(bf2.test("foo")).toBe(true);
    });

    it("should initialize the field with the right size", function() {
      bf = new JsonBloomfilter({size: 100});
      expect(bf.toHash()["bits"].length).toBe(4);
    });
  });

  describe("with an instance", function() {
    var bf;

    beforeEach(function() {
      bf = new JsonBloomfilter();
      bf.add("foobar");
    });

    describe("#add, #test", function() {
      it("should add a key", function() {
        expect(bf.test("foo")).toBe(false);
        bf.add("foo");
        expect(bf.test("foo")).toBe(true);
      });

      it("should be able to add and test more than one key at a time", function() {
        expect(bf.test("foo")).toBe(false);
        expect(bf.test("bar")).toBe(false);
        bf.add(["foo", "bar"]);
        expect(bf.test(["foo", "bar"])).toBe(true);
      });

      it("should not change anything if added twice", function() {
        expect(bf.test("foobar")).toBe(true);
        bits = bf.toHash()["bits"];
        bf.add("foobar");
        expect(bf.test("foobar")).toBe(true);
      });
    });

    describe("#clear", function() {
      it("should clear the bit array", function() {
        expect(bf.bits.toString()).not.toBe("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
        bf.clear();
        expect(bf.bits.toString()).toBe("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
      });
    });

    describe("#toHash", function() {
      it("should return the serialisable hash", function() {
        hash = bf.toHash();
        expect(hash instanceof Object).toBe(true);
        expect(hash["seed"]).not.toBeUndefined();
        expect(hash["hashes"]).not.toBeUndefined();
        expect(hash["size"]).not.toBeUndefined();
        expect(hash["bits"]).not.toBeUndefined();
      });
    });

    describe("#toJson", function() {
      it("should return the hash serialised", function() {
        expect(bf.toJson()).toBe(JSON.stringify(bf.toHash()));
      });
    });

  });
});