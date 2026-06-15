-- Tetris Clone - A modular Tetris game in Lua using LÖVE2D
-- Entry point for the game
-- Compatible with LÖVE2D 11.5

local GameLoop = require('core.GameLoop')

local game = nil
local canvas = nil

function love.load(arg)
    math.randomseed(os.time())
    
    local windowWidth = 600
    local windowHeight = 650
    
    love.window.setMode(windowWidth, windowHeight, {
        resizable = false,
        centered = true,
        minwidth = 400,
        minheight = 400
    })
    
    love.window.setTitle('Tetris Clone')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    canvas = love.graphics.newCanvas(windowWidth, windowHeight)
    
    game = GameLoop.new()
    game:run()
end

function love.update(dt)
    if game then
        game:update(dt)
    end
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    if game then
        game:draw()
    end
    
    love.graphics.setCanvas()
    love.graphics.draw(canvas)
end

function love.keypressed(key, scancode, isrepeat)
    if game then
        game:keyPressed(key)
    end
end

function love.keyreleased(key, scancode)
    if game then
        game:keyReleased(key)
    end
end

function love.quit()
    if game then
        game:stop()
    end
end