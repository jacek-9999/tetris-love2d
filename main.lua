-- Tetris Clone - A modular Tetris game in Lua using LÖVE2D
-- Entry point for the game

local GameLoop = require('core.GameLoop')

local game = nil

function love.load(arg)
    math.randomseed(os.time())
    
    local windowWidth = 600
    local windowHeight = 650
    
    if arg and #arg > 0 then
        for i, v in ipairs(arg) do
            if v == '--fullscreen' then
                love.window.setMode(0, 0, {fullscreen = true})
                return
            end
        end
    end
    
    love.window.setMode(windowWidth, windowHeight, {
        resizable = false,
        centered = true
    })
    
    love.window.setTitle('Tetris Clone')
    
    game = GameLoop.new()
    game:run()
end

function love.update(dt)
    if game then
        game:update(dt)
    end
end

function love.draw()
    if game then
        game:draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    if game then
        game:keyPressed(key)
    end
    
    if key == 'escape' then
        if game and game:getGameState():getStateName() ~= 'menu' then
            -- Let the state handle escape
        end
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