describe "A table", ->
  Table = require("../src/tabular-data.coffee").Table
  table = undefined
  input = undefined

  describe "Given an array of arrays and some means of determining the key for each row", ->

    beforeEach ->
      input = [
        [ 'code'    , 'de'      , 'en'      ]
        [ 'foo'     , 'Das Foo' , 'The Foo' ]
        [ 'bar'     , 'Dem Bar' , 'The Bar' ]
      ]
      table = Table.fromArrays input, 0

    it "can produce the original array of arrays", ->
      expect(table.toArrays()).toEqual input

    it "interpretes the first array as headers", ->
      expect(table.headers()).toEqual ['code','de','en']

    it "can produce an array of row-hashes from the remaining arrays, using the headers as keys", ->
      expect(table.toHashes()).toEqual [
        {code: 'foo', de:'Das Foo', en:'The Foo'}
        {code: 'bar', de:'Dem Bar', en:'The Bar'}
      ]
    
    it "can produce a hash of hashes", ->
      expect(table.toHash()).toEqual
        foo:
          code: 'foo', de:'Das Foo', en:'The Foo'
        bar:
          code: 'bar', de:'Dem Bar', en:'The Bar'

    it "can derive the row keys from a column header instead of a column index", ->
      table = Table.fromArrays input,'code'
      expect(table.toHash()).toEqual
        foo:
          code: 'foo', de:'Das Foo', en:'The Foo'
        bar:
          code: 'bar', de:'Dem Bar', en:'The Bar'

    it "can work with custom row keys by running a callback", ->
      table = Table.fromArrays input, (ar) -> ar[0].toUpperCase()
      expect(table.toHash()).toEqual
        FOO:
          code: 'foo', de:'Das Foo', en:'The Foo'
        BAR:
          code: 'bar', de:'Dem Bar', en:'The Bar'


  describe "Given an Array of Hashes and some means of determining row keys", ->

    beforeEach ->
      input=[
        {code: 'foo', de:'Das Foo', en:'The Foo'}
        {code: 'bar', de:'Dem Bar', en:'The Bar'}
      ]
      table = Table.fromHashes input, 'code'

    it "can produce the original array of hashes", ->
      expect(table.toHashes()).toEqual input

    it "can produce an array of arrays, with the first one containing the column headers", ->
      expect(table.toArrays()).toEqual [
        [ 'code'    , 'de'      , 'en'      ]
        [ 'foo'     , 'Das Foo' , 'The Foo' ]
        [ 'bar'     , 'Dem Bar' , 'The Bar' ]
      ]

    it "can produce a hash of hashes", ->
      expect(table.toHash()).toEqual
        foo:
          code: 'foo', de:'Das Foo', en:'The Foo'
        bar:
          code: 'bar', de:'Dem Bar', en:'The Bar'

    it "can work with custom row keys by running a callback", ->
      table = Table.fromHashes input, (ar) -> ar.code.toUpperCase()
      expect(table.toHash()).toEqual
        FOO:
          code: 'foo', de:'Das Foo', en:'The Foo'
        BAR:
          code: 'bar', de:'Dem Bar', en:'The Bar'

  describe "Given a hash of hashes", ->
    beforeEach ->
      input =
        foo:
          code: 'foo', de:'Das Foo', en:'The Foo'
        bar:
          code: 'bar', de:'Dem Bar', en:'The Bar'
      table = Table.fromHash input, 'code'

    it "can produce the original hash of hashes", ->
      expect(table.toHash()).toEqual input

    it "can produce an array of arrays, with the first one containing the column headers", ->
      expect(table.toArrays()).toEqual [
        [ 'code'    , 'de'      , 'en'      ]
        [ 'foo'     , 'Das Foo' , 'The Foo' ]
        [ 'bar'     , 'Dem Bar' , 'The Bar' ]
      ]

    it "can produce an array of row-hashes", ->
      expect(table.toHashes()).toEqual [
        {code: 'foo', de:'Das Foo', en:'The Foo'}
        {code: 'bar', de:'Dem Bar', en:'The Bar'}
      ]
