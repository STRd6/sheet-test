# TODO: Error messaging

compile = (src) ->
  CoffeeScript.compile src, bare: true

add = (a, b) ->
  a + b

flatten = (array) ->
  array.reduce (a, b) ->
    a.concat b
  , []

fns =
  "+": (args...) ->
    flatten(args).reduce(add, 0)

Object.keys(fns).forEach (name) ->
  fns[name].toString = -> name

callableString = (str) ->
  fns[str] or str

rangeRegex = /^([A-Z])(\d+):([A-Z])(\d+)$/

# A -> B -> C, ...
# TODO: Multi-character string
# TODO: Z -> AA
# TODO: AA -> AB
# TODO: AZ -> BA
succ = (s) ->
  String.fromCharCode(s.charCodeAt(0) + 1)

# Ranges
# A1:A10
# A1:B2
#
# TO LATER
# B2:A1
# A:B
# A:A
# A4:B
# A:B3
Range = (address) ->
  match = address.match rangeRegex

  if match
    [_, startColumn, startRow, endColumn, endRow] = match
    startRow = parseInt(startRow, 10)
    endRow = parseInt(endRow, 10)

    map: (fn) ->
      results = []
      col = startColumn
      row = startRow

      while col <= endColumn
        while row <= endRow
          results.push fn("#{col}#{row}")
          row += 1

        col = succ(col)
        row = startRow

      return results

module.exports = (data) ->
  # Cache computed values
  values = {}

  evaluate = (address) ->
    value = values[address]
    return value unless value is undefined

    source = data[address] ? ""

    if source.toString().match /^=/
      code = compile source.substr(1)
      value = Function("return " + code).call(proxy)
    else
      value = switch typeof source
        when "string"
          callableString source
        else
          source

    values[address] = value

  proxy = new Proxy data,
    get: (target, property, receiver) ->
      console.log "GET", property

      range = Range property
      if range
        range.map evaluate
      else
        evaluate property

  return proxy
