define ["../indexer", "thirdparty/sugar"], (Indexer) ->
  csgToGmsh = (solid) ->
    data =
      point: [],
      line: [], lineLoop: [], planeSurface: [],
      surfaceLoop: [], volume: []
    pointIndexer = new Indexer
    lineIndexer = new Indexer
    for polygon in solid.toPolygons()
      points = for v in polygon.vertices
        console.log point, i if v.pos == undefined
        pointIndexer.add [v.pos.x, v.pos.y, v.pos.z]

      lines = []
      lines.push lineIndexer.add([points[points.length-1], points[0]])
      for i in [1...points.length]
        lines.push lineIndexer.add([points[i-1], points[i]])

      data.planeSurface.push [data.lineLoop.length]
      data.lineLoop.push lines

    data.point = pointIndexer.unique
    data.line = lineIndexer.unique

    # TODO: handle more than one volue, if necessary
    # TODO: need specific ordering?
    data.volume.push [data.surfaceLoop.length]
    data.surfaceLoop.push data.planeSurface

    output = []
    for key, objects of data
      name = key.spacify().capitalize(yes)
      for values, index in objects
        if key == 'point'
          values = values.join ', '
        else # TODO: Either remove conditional, or add 1 to indices if necessary.
          values = values.join ', '
        output += "#{name}(#{index}) = {#{values}};\n"

    output

