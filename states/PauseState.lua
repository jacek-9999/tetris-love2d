-- PauseState: Pause menu during gameplay
local State = require('states.State')
local constants = require('lib.constants')

local PauseState = setmetatable({}, {__index = State})
PauseState.__index = PauseState

function PauseState.new(stateMachine)
    local self = setmetatable(State.new(stateMachine), PauseState)
    self:init()
    return self
end

function PauseState:init()
    self.options = {'Resume', 'Restart', 'Main Menu'}
    self.selectedIndex = 1
    self.prevState = nil
    self.menuFont = nil
end

function PauseState:enter(prevState)
    self.prevState = prevState
    self.selectedIndex = 1
end

function PauseState:loadFonts()
    if not self.menuFont then
        self.menuFont = love.graphics.newFont(24)
    end
end

function PauseState:handleInput(input)
    if input:justPressed('up') or input:justPressed('w') then
        self.selectedIndex = self.selectedIndex - 1
        if self.selectedIndex < 1 then
            self.selectedIndex = #self.options
        end
    elseif input:justPressed('down') or input:justPressed('s') then
        self.selectedIndex = self.selectedIndex + 1
        if self.selectedIndex > #self.options then
            self.selectedIndex = 1
        end
    elseif input:justPressed('return') or input:justPressed('space') then
        self:selectOption()
    elseif input:justPressed('escape') or input:justPressed('p') then
        self.stateMachine:change('play')
    end
end

function PauseState:selectOption()
    if self.selectedIndex == 1 then
        self.stateMachine:change('play')
    elseif self.selectedIndex == 2 then
        self.stateMachine:change('play')
    elseif self.selectedIndex == 3 then
        self.stateMachine:change('menu')
    end
end

function PauseState:draw()
    self:loadFonts()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    if self.prevState and self.prevState.draw then
        self.prevState:draw()
    end
    
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', 0, 0, width, height)
    
    love.graphics.setFont(self.menuFont)
    love.graphics.setColor(constants.COLORS.TEXT)
    love.graphics.printf('PAUSED', 0, height / 3, width, 'center')
    
    for i, option in ipairs(self.options) do
        local y = height / 2 + (i - 1) * 50
        if i == self.selectedIndex then
            love.graphics.setColor(constants.COLORS.HIGHLIGHT)
            love.graphics.printf('> ' .. option .. ' <', 0, y, width, 'center')
        else
            love.graphics.setColor(constants.COLORS.TEXT)
            love.graphics.printf(option, 0, y, width, 'center')
        end
    end
end

return PauseState