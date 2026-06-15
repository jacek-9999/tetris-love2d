-- LÖVE2D Configuration
function love.conf(t)
    t.title = 'Tetris Clone'
    t.version = '1.0.0'
    t.author = 'Tetris Clone'
    t.window.width = 600
    t.window.height = 650
    t.window.resizable = false
    t.console = false
    
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.keyboard = true
    t.modules.mouse = true
    t.modules.timer = true
    t.modules.window = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.sound = true
    t.modules.math = true
    t.modules.physics = false
    t.modules.joystick = false
end