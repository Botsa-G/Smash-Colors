function love.conf(t)
t.title = "Smash The Colors"
t.author = "Botsa"
t.url = nil
t.identity =  "Smash The Colors"
t.version =  (11.4)--"11.3"
t.console = false
t.release = false
t.window.icon = "ic.png"
t.window.width = 360
t.window.height = 640
--t.screen.fullscreen = false
--t.screen.vsync = true
--t.screen.fsaa = 0
t.modules.joystick = true 
t.modules.audio = true
t.modules.keyboard = true
t.modules.event = true
t.modules.image = true
t.modules.graphics = true
t.modules.timer = true
t.modules.mouse = true
t.modules.sound = true
t.modules.physics = true



end