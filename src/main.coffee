require ["csgToThreeGeometry", "thirdparty/Three", "thirdparty/csg", 
  "thirdparty/sugar"], (csgToThreeGeometry) ->
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

  renderer = new Three.WebGLRenderer
  container.appendChild renderer.domElement

  camera = new Three.PerspectiveCamera 45, placeholder, 0.01, 1000
  camera.position.set 5, 5, 5
  scene.add camera

  controls = new Three.TrackballControls camera, container

  keyLight = new Three.DirectionalLight 0xFFFFFF
  keyLight.position.set 7, 10, 0
  scene.add keyLight
  fillLight = new Three.DirectionalLight 0x666666
  fillLight.position.set 0, 4, 7
  scene.add fillLight

  # Live code
  mesh = null
  update = ->
    console.log "update"
    solid = new Function(textarea.value)()

    scene.remove mesh if mesh?
    geometry = csgToThreeGeometry solid
    #geometry = new Three.CubeGeometry 1, 1, 1
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
