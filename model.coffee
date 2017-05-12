{Observable} = require "jadelet"

self = ->

  hello: 'sup'

  clickTest: ->
    alert 'yo'

  value: Observable(5)
    
module.exports = self
