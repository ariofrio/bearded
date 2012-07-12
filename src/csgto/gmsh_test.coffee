require '../thirdparty/csg'
{exec} = require('child_process')
tmp = require 'tmp'
fs = require 'fs'
should = require 'should'

csgToGmsh = require './gmsh'

# Run `gmsh` on a geometry (in .geo format) and assert that it succeeds.
gmshSucceedsWith = (geometry, done) ->
  tmp.file postfix: '.geo', (err, path, fd) ->
    throw err if err?
    fs.writeFile path, geometry, (err) ->
      throw err if err?
      exec "gmsh -3 #{path}", (err, stdout, stderr) ->
        #console.log stdout
        #console.log stderr
        fs.unlink "#{path[...path.length-4]}.msh", (err2) ->
          throw err2 if err2?
          try
            should.not.exist err
            done()
          catch e
            done(e)

describe 'csgToGmsh', ->
  beforeEach -> @it = csgToGmsh

  it 'supports a cube', (done) ->
    gmshSucceedsWith csgToGmsh(CSG.cube()), done
  it 'supports a sphere', (done) ->
    gmshSucceedsWith csgToGmsh(CSG.sphere()), done

  it 'supports the union of two concentric cubes', (done) ->
    gmshSucceedsWith csgToGmsh(CSG.cube().union(
      CSG.cube(radius: 0.5))), done
  it 'supports the union of two overlapping cubes', (done) ->
    gmshSucceedsWith csgToGmsh(CSG.cube().union(
      CSG.cube(radius: 0.5, center: [0, 0, 1]))), done
