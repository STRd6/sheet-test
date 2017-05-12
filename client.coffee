# This client-side CoffeeScript is compiled 
# by express browserify middleware using the
# coffeeify transform

Sheet = require "./sheet"

sheet = Sheet
  A1: 5
  A2: 4
  A3: 3
  A4: 2
  A5: 1
  A6: 0
  A7: -1
  B7: 12
  C3: "= @A1 + @D4"
  D4: "= @F2(@B7, 2)"
  F1: "= (a, b) -> a * b"
  F2: "+"
  G1: "= @F2(@F2, @F2)"
  G2: "= @F2 @['A1:A7']"
  G3: "= @G4 = 7"

console.log sheet.C3, sheet.G2, sheet.G3, sheet.G4
