-- GameOverState: Game over screen with score display
local State = require('states.State')
local constants = require('lib.constants')

local GameOverState = setmetatable({}, {__index = State})
GameOverState.__index = GameOverState

function GameOverState.new(stateMachine)
    local self = setmetatable(State.new(stateMachine), GameOverState)
    self:init()
    return self
end

function GameOverState:init()
    self.options = {'Play Again', 'Main Menu'}
    self.selectedIndex = 1
    self.score = 0
    self.level = 1
    self.linesCleared = 0
    self.titleFont = nil
    self.menuFont = nil
    self.scoreFont = nil
end

function GameOverState:enter(prevState)
    if prevState then
        self.score = prevState.score or 0
        self.level = prevState.level or 1
        self.linesCleared = prevState.linesCleared or 0
    end
    self.selectedIndex = 1
end

function GameOverState:loadFonts()
    if not self.titleFont then
        self.titleFont = love.graphics.newFont(48)
        self.menuFont = love.graphics.newFont(24)
        self.scoreFont = love.graphics.newFont(20)
    end
end

function GameOverState:handleInput(input)
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
    end
end

function GameOverState:selectOption()
    if self.selectedIndex == 1 then
        self.stateMachine:change('play')
    elseif self.selectedIndex == 2 then
        self.stateMachine:change('menu')
    end
end

function GameOverState:draw()
    self:loadFonts()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    love.graphics.setBackgroundColor(constants.COLORS.BACKGROUND)
    
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(constants.PIECES.Z)
    love.graphics.printf('GAME OVER', 0, height / 4, width, 'center')
    
    love.graphics.setFont(self.scoreFont)
    love.graphics.setColor(constants.COLORS.TEXT)
    love.graphics.printf('Final Score: ' .. self.score, 0, height / 2.5, width, 'center')
    love.graphics.printf('Level: ' .. self.level, 0, height / 2.5 + 30, width, 'center')
    love.graphics.printf('Lines Cleared: ' .. self.linesCleared, 0, height / 2.5 + 60, width, 'center')
    
    love.graphics.setFont(self.menuFont)
    for i, option in ipairs(self.options) do
        local y = height * 0.7 + (i - 1) * 50
        if i == self.selectedIndex then
            love.graphics.setColor(constants.COLORS.HIGHLIGHT)
            love.graphics.printf('> ' .. option .. ' <', 0, y, width, 'center')
        else
            love.graphics.setColor(constants.COLORS.TEXT)
            love.graphics.printf(option, 0, y, width, 'center')
        end
    end
end

return GameOverState