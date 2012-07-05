define [], ->
  # Stolen and adapted from http://evanw.github.com/lightgl.js/docs/mesh.html
  class Indexer
    constructor: ->
      @unique = []
      @indices = []
      @map = {}
    add: (obj) ->
      key = JSON.stringify(obj)
      if key not in @map
        @map[key] = @unique.length
        @unique.push obj
      @map[key]
