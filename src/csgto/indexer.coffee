`if(typeof define!=='function'){var define = require('amdefine')(module)}`

define [], ->
  # Stolen and adapted from http://evanw.github.com/lightgl.js/docs/mesh.html
  class Indexer
    constructor: ->
      @unique = []
      @indices = []
      @map = {}
    add: (obj) ->
      key = JSON.stringify(obj)
      if key not of @map
        @map[key] = @unique.length
        @unique.push obj
      @map[key]
