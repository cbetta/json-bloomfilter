describe("JsonBloomfilter.Zlib", function() {

  describe("#crc32", function() {
     it("should hash the input correctly", function() {
       expect(JsonBloomfilter.Zlib.crc32("foobar")).toBe(2666930069);
       expect(JsonBloomfilter.Zlib.crc32("Magna Pellentesque Egestas Nibh Ultricies")).toBe(1920919084);
     });

   });
});