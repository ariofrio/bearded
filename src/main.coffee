require ["csgto/three", "csgto/gmsh",
  "thirdparty/sugar", "thirdparty/Three", "thirdparty/csg", 
  "thirdparty/FileSaver", "thirdparty/BlobBuilder",
  "thirdparty/Detector"], (csgToThree, csgToGmsh) ->
  Three = THREE
  
  # Might want to use Function.bind(document) instead.
  $ = (query) -> document.querySelector query
  $$ = (query) -> document.querySelectorAll query

  # A placeholder for values that will be updated later. DRY.
  placeholder = "If this is being used, we've got a problem."

  # Elements
  textarea = $("textarea")
  container = $("#canvas")

  # Scene, renderer, camera, control, lights
  scene = new Three.Scene

  renderer = if Detector.webgl then new Three.WebGLRenderer else new Three.CanvasRenderer
  container.appendChild renderer.domElement

  camera = new Three.PerspectiveCamera 45, placeholder, 0.01, 1000
  camera.position.set 5, 5, 5
  scene.add camera

  controls = new Three.TrackballControls camera, container

  keyLight = new Three.DirectionalLight 0xFFFFFF
  keyLight.position.set 7, 10, 0
  scene.add keyLight
  fillLight = new Three.DirectionalLight 0x666666
  fillLight.position.set -5, 7, 4
  scene.add fillLight
  bottomLight = new Three.DirectionalLight 0x666666
  bottomLight.position.set 7, -5, 4
  scene.add bottomLight
  backLight = new Three.DirectionalLight 0xFFFFFF
  backLight.position.set -5, -7, -4
  scene.add backLight

  # Live code
  mesh = null
  solid = null
  update = ->
    console.log "update"
    solid = new Function(textarea.value)()

    scene.remove mesh if mesh?
    geometry = csgToThree solid
    mesh = new Three.Mesh geometry,
      new Three.MeshLambertMaterial(color: 0xCC0000)
    scene.add mesh
  update = update.throttle 250
  textarea.addEventListener 'keyup', update
  textarea.addEventListener 'change', update
  update()

  # Responsive resizing
  window.addEventListener 'resize', onresize = ->
    renderer.setSize container.clientWidth, container.clientHeight
    camera.aspect = container.clientWidth/container.clientHeight
    camera.updateProjectionMatrix()
  onresize()

  # Rendering loop
  render = ->
    requestAnimationFrame render
    controls.update()
    renderer.render scene, camera
  render()

  # Saving
  $("#save").addEventListener 'click', ->
    bb = new BlobBuilder
    bb.append csgToGmsh(solid)
    saveAs bb.getBlob("text/plain;charset=utf-8"), "geometry.geo"

