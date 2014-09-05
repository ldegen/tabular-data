utils = require("./utils")


fromArrays = (rows0, key0) ->
  rows=Array::slice.call(rows0)
  headers = rows.shift()
  key = switch typeof key0
    when "number" then (d) -> d[key0]
    when "function" then key0
    when "string" then (d) -> d[headers.indexOf key0]
    else throw new Error("bad key argument: "+key0)
  hashFromRow = (row) -> utils.hashFromArray(row,((c,i) -> headers[i]))
  
  headers: -> headers
  toHash: -> utils.hashFromArray rows, key, hashFromRow
  toHashes: -> rows.map hashFromRow
  toArrays: -> rows0

fromHashes = (hashes, key0) ->
  headers = utils.collectKeys(hashes)
  key = switch typeof key0
    when "function" then key0
    else (hash) -> hash[key0]

  headers: -> headers
  toHash: -> utils.hashFromArray hashes, key
  toHashes: -> hashes
  toArrays: -> [headers].concat hashes.map (hash) -> headers.map (header)->hash[header]

fromHash = (hash) ->
  hashes =  (v for k,v of hash)
  headers = utils.collectKeys hashes
  headers: -> headers
  toHash: -> hash
  toHashes: -> hashes
  toArrays: -> [headers].concat hashes.map (hash) ->  headers.map (header)->hash[header]
  
  
module.exports.fromArrays=fromArrays
module.exports.fromHashes=fromHashes
module.exports.fromHash=fromHash
