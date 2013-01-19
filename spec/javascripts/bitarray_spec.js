describe("JsonBloomfilter.BitArray", function() {

  describe("#initialize", function() {
    it("should require a size", function() {
      expect(function(){new JsonBloomfilter.BitArray()}).toThrow("Missing argument: size")
    });

    it("should take an optional bit field", function() {
      field = [0,0,0,2];
      ba = new JsonBloomfilter.BitArray(100, field);
      expect(ba.field).toBe(field);
    });

    it("should create the right size field"), function() {
      ba = new JsonBloomfilter.BitArray(100);
      expect(ba.field.length).toBe(4);
    });
  });

  describe("#add", function() {
    it("should set the bit to 1", function() {
      ba = new JsonBloomfilter.BitArray(10);
      ba.add(9);
      expect(ba.toString()).toBe("0000000001");
    });

    it("should throw an error on out of bound", function() {
      ba = new JsonBloomfilter.BitArray(10);
      ba.add(9);
      expect(function(){ba.add(10);}).toThrow("BitArray index out of bounds");
    });
  });

  describe("#remove", function() {
    it("should set the bit to 0", function() {
      ba = new JsonBloomfilter.BitArray(10);
      ba.add(9);
      ba.remove(9);
      expect(ba.toString()).toBe("0000000000");
    });

    it("should throw an error on out of bound", function() {
      ba = new JsonBloomfilter.BitArray(10);
      expect(function(){ba.remove(10);}).toThrow("BitArray index out of bounds");
    });
  });

  describe("#get", function() {
    it("should return the bit set", function() {
      ba = new JsonBloomfilter.BitArray(10);
      ba.add(9);
      expect(ba.get(9)).toBe(1);
      expect(ba.get(8)).toBe(0);
    });

    it("should throw an error on out of bound", function() {
      ba = new JsonBloomfilter.BitArray(10);
      expect(function(){ba.get(10);}).toThrow("BitArray index out of bounds");
    });
  });

  describe("#toString", function() {
    it("should output the bit string", function() {
      ba = new JsonBloomfilter.BitArray(10);
      ba.add(3);
      ba.add(9);
      expect(ba.toString()).toBe("0001000001");
    });
  });
});