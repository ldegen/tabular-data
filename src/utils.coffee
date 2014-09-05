typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'


module.exports.collectKeys = (ar) ->
  ar.reduce (keys,obj) ->
    keys.concat((key for key of obj).filter (key) -> keys.indexOf(key) == -1)
  , []

module.exports.hashFromArray = hashFromArray = (array, key,val) ->
  key ?= (d,i) -> i
  val ?= (d) -> d
  array.reduce (lookup,elm,i)->
    r=key(elm,i)
    [k,v] = if typeIsArray(r) then r else [r,val(elm,i)]
    lookup[k] = v
    lookup
  , {}

module.exports.hashFromHash = (obj,val,key) ->
  key ?= (d,i) -> i
  val ?= (d) -> d
  lookup = {}
  for i,elm of obj
    r=val(elm,i)
    [k,v] = if typeIsArray(r) then r else [key(elm,i),r]
    lookup[k] = v
  lookup
