define ["../indexer", "thirdparty/Three", "thirdparty/sugar"], (Indexer) ->
  Three = THREE

  csgToThree = (solid) ->
    geometry = new Three.Geometry
    indexer = new Indexer
    for polygon in solid.toPolygons()
      indices = (indexer.add(vertex) for vertex in polygon.vertices)
      
      # Any n-polygon can be represented as n-2 triangles.
      for i in [2...indices.length]
        geometry.faces.push new Three.Face3(indices[0], indices[i-1],
          indices[i], new Three.Vector3().copy polygon.plane.normal)

    geometry.vertices = for v in indexer.unique
      new Three.Vector3(v.pos.x, v.pos.y, v.pos.z)

    geometry
