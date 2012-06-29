define ["thirdparty/Three", "thirdparty/sugar"], ->
  Three = THREE

  # Stolen from http://evanw.github.com/lightgl.js/docs/mesh.html
  class Indexer
    unique: []
    indices: []
    map: {}
    add: (obj) ->
      key = JSON.stringify(obj)
      if key not in @map
        @map[key] = @unique.length
        @unique.push obj
      @map[key]

  return (solid) ->
    geometry = new Three.Geometry
    indexer = new Indexer
    for polygon in solid.toPolygons()
      indices = (indexer.add(vertex) for vertex in polygon.vertices)
      
      for i in [2...indices.length]
        geometry.faces.push new Three.Face3(indices[0], indices[i-1],
          indices[i], new Three.Vector3().copy polygon.plane.normal)

    geometry.vertices = for v in indexer.unique
      new Three.Vector3(v.pos.x, v.pos.y, v.pos.z)

    geometry
