-- InputHandler: Manages keyboard input for the game
local utils = require('lib.utils')

local InputHandler = {}
InputHandler.__index = InputHandler

function InputHandler.new()
    local self = setmetatable({}, InputHandler)
    self:init()
    return self
end

function InputHandler:init()
    self.keysPressed = {}
    self.keysJustPressed = {}
    self.keysJustReleased = {}
    self.repeatDelays = {}
    self.keyRepeatInterval = 0.1
    self.initialRepeatDelay = 0.2
end

function InputHandler:update(dt)
    for key, _ in pairs(self.keysJustPressed) do
        self.keysJustPressed[key] = nil
    end
    
    for key, data in pairs(self.repeatDelays) do
        data.delay = data.delay - dt
        if data.delay <= 0 then
            data.delay = self.keyRepeatInterval
            self.keysJustPressed[key] = true
        end
    end
    
    for key, _ in pairs(self.keysJustReleased) do
        self.keysJustReleased[key] = nil
    end
end

function InputHandler:keyPressed(key)
    if not self.keysPressed[key] then
        self.keysPressed[key] = true
        self.keysJustPressed[key] = true
        
        self.repeatDelays[key] = {
            delay = self.initialRepeatDelay
        }
        
        return true
    end
    return false
end

function InputHandler:keyReleased(key)
    self.keysPressed[key] = nil
    self.keysJustReleased[key] = true
    self.repeatDelays[key] = nil
end

function InputHandler:isDown(key)
    return self.keysPressed[key] == true
end

function InputHandler:justPressed(key)
    return self.keysJustPressed[key] == true
end

function InputHandler:justReleased(key)
    return self.keysJustReleased[key] == true
end

function InputHandler:clear()
    self.keysPressed = {}
    self.keysJustPressed = {}
    self.keysJustReleased = {}
    self.repeatDelays = {}
end

return InputHandler