define = @define || require('amdefine')(module)

define ["./indexer"], (Indexer) ->
  csgToGmsh = (solid) ->
    # Keep the geometry objects in one place. Each kind of object is
    # represented by a list, where index = id - 1 and the values are the
    # objects themselves. Points are 3D vectors, while the others are 
    # 1-based id lists
    data =
      point: [],
      line: [], lineLoop: [], planeSurface: [],
      surfaceLoop: [], volume: []

    # Points and lines can be duplicated by CSG, but must be unique
    # to avoid "Self intersecting surface mesh, computing intersections"
    # in Gmsh.
    pointIndexer = new Indexer
    lineIndexer = new Indexer

    # Now, go through each polygon (face) in our CSG object.
    for polygon in solid.toPolygons()
      # For each point in the face, create or find an id to represent it.
      # We don't add the points to the geometry data yet.
      pointIds = for {pos: {x, y, z}} in polygon.vertices
        1 + pointIndexer.add [x, y, z]

      # Create lines between the points and create or find an id for each
      # line. We don't add the lines to the geometry data yet.
      #
      # We also make sure to always put the smallest ids first and the other
      # one second. However, we need to negate the id if we reversed the
      # polarity/direction of the line, when we use it to create a line
      # loop.
      lineIds = for thisId, i in pointIds
        otherId = if i is 0 then pointIds[pointIds.length - 1] else pointIds[i-1]
        if thisId < otherId
          1 + lineIndexer.add [thisId, otherId]
        else
          -(1 + lineIndexer.add [otherId, thisId])

      # Create a line loop with these lines, and a plane surface from the
      # line loop. Add both to the geometry data.
      data.lineLoop.push lineIds
      data.planeSurface.push [data.lineLoop.length] # 1-based ids, remember?

    # Add the points and lines we created to the geometry data.
    data.point = pointIndexer.unique
    data.line = lineIndexer.unique

    # Create a surface loop with all the surfaces we created, and
    # a volume from the surface loop. Add both to the geometry data.
    # TODO: handle more than one volue, if necessary
    # TODO: need specific ordering?
    data.surfaceLoop.push [1..data.planeSurface.length]
    data.volume.push [data.surfaceLoop.length] # 1-based ids, remember?

    # Finally, write out the data in .geo format.
    output = []
    for key in ['point', 'line', 'lineLoop', 'planeSurface', 'surfaceLoop', 'volume']
      name = key.spacify().capitalize(yes)
      for object, id in data[key]
        object = object.join ', '
        output += "#{name}(#{id + 1}) = {#{object}};\n"
    output

