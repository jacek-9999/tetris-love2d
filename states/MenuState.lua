-- MenuState: Main menu with start and quit options
local State = require('states.State')
local constants = require('lib.constants')

local MenuState = setmetatable({}, {__index = State})
MenuState.__index = MenuState

function MenuState.new(stateMachine)
    local self = setmetatable(State.new(stateMachine), MenuState)
    self:init()
    return self
end

function MenuState:init()
    self.options = {'Start Game', 'Quit'}
    self.selectedIndex = 1
    self.title = 'TETRIS'
    self.titleFont = nil
    self.menuFont = nil
end

function MenuState:enter()
    self.selectedIndex = 1
end

function MenuState:loadFonts()
    if not self.titleFont then
        self.titleFont = love.graphics.newFont(48)
        self.menuFont = love.graphics.newFont(24)
    end
end

function MenuState:handleInput(input)
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

function MenuState:selectOption()
    if self.selectedIndex == 1 then
        self.stateMachine:change('play')
    elseif self.selectedIndex == 2 then
        love.event.quit()
    end
end

function MenuState:draw()
    self:loadFonts()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    love.graphics.setBackgroundColor(constants.COLORS.BACKGROUND)
    
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(constants.COLORS.TEXT_SHADOW)
    love.graphics.printf(self.title, 3, height / 4 + 3, width, 'center')
    love.graphics.setColor(constants.COLORS.TEXT)
    love.graphics.printf(self.title, 0, height / 4, width, 'center')
    
    love.graphics.setFont(self.menuFont)
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

return MenuState