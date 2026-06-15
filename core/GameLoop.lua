-- GameLoop: Main game loop orchestration
local GameState = require('core.GameState')

local GameLoop = {}
GameLoop.__index = GameLoop

function GameLoop.new()
    local self = setmetatable({}, GameLoop)
    self:init()
    return self
end

function GameLoop:init()
    self.gameState = GameState.new()
    self.isRunning = true
    self.targetFPS = 60
    self.dt = 0
    self.accumulator = 0
    self.fixedDeltaTime = 1 / 60
end

function GameLoop:run()
    self.isRunning = true
end

function GameLoop:stop()
    self.isRunning = false
end

function GameLoop:update(dt)
    self.dt = dt
    self.gameState:update(dt)
end

function GameLoop:draw()
    self.gameState:draw()
end

function GameLoop:keyPressed(key)
    self.gameState:keyPressed(key)
end

function GameLoop:keyReleased(key)
    self.gameState:keyReleased(key)
end

function GameLoop:getGameState()
    return self.gameState
end

return GameLoop