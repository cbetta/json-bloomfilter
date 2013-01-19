describe("JsonBloomfilter.Zlib", function() {

  describe("#initialize", function() {
    it("should crc32 the input", function() {
      expect(JsonBloomfilter.Zlib.crc32("foobar")).toBe(2666930069);
      expect(JsonBloomfilter.Zlib.crc32("Magna Pellentesque Egestas Nibh Ultricies")).toBe(1920919084);
    });

  });
});