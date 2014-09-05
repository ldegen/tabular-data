
describe "Utility Functions", ->
  utils = require('../src/utils')
  
  describe "The collectKeys()-Function", ->
    it "collects all keys ocurring in the objects contained in an array", ->
      input = [
        a:1
        b:2
      ,
        b:3
        c:4
      ]

      expect(utils.collectKeys(input)).toEqual ['a','b','c']

  describe "The hashFromArray()-Function", ->
    input = [
      a:1
      b:2
    ,
      b:3
      c:4
    ]
    it "builds a hash from an array, using the provided callback to extract the keys from the elements", ->
      lookup = utils.hashFromArray input, (d) -> d.b*d.b
      expect(lookup).toEqual
        4:
          a:1
          b:2
        9:
          b:3
          c:4

    it "supports callbacks returning a [key,value] pair to modify the elements on the fly", ->
      lookup = utils.hashFromArray input, (d) -> [d.b, d.b*d.b]
      expect(lookup).toEqual
        2:4
        3:9

    it "alternatively supports using two separate callbacks for mapping keys and values", ->
      lookup = utils.hashFromArray input, ((d) ->d.b), ((d)->d.b*d.b)
      expect(lookup).toEqual
        2:4
        3:9

    it "provides the callbacks with the current array index via the second argument", ->
      lookup = utils.hashFromArray input, ((d,i) ->d.b+10*i), ((d,i)->d.b*d.b+10*i)
      expect(lookup).toEqual
        2:4
        13:19

  describe "The hashFromHash()-Function", ->
    input =
      x:
        a:1
      y:
        a:2

    it "builds a hash from a hash, using the provided callback to transform the original values", ->
      lookup = utils.hashFromHash input, (d) -> {b:d}
      expect(lookup).toEqual
        x:
          b:
            a:1
        y:
          b:
            a:2

    it "supports callbacks returning a [key,value] pair to modify the keys on the fly", ->
      lookup = utils.hashFromHash input, (d) -> [d.a, d.a*d.a]
      expect(lookup).toEqual
        1:1
        2:4

    it "alternatively supports using two separate callbacks for mapping keys and values", ->
      lookup = utils.hashFromHash input, ((d) ->d.a*d.a), ((d)->d.a)
      expect(lookup).toEqual
        1:1
        2:4

    it "provides the callbacks with the current key via the second argument", ->
      lookup = utils.hashFromHash input, ((d,i) ->d.a*d.a+i), ((d,i)->d.a+i)
      expect(lookup).toEqual
        '1x':'1x'
        '2y':'4y'

