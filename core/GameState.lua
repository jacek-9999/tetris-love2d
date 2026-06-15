-- GameState: State machine managing all game states
local State = require('states.State')
local MenuState = require('states.MenuState')
local PlayState = require('states.PlayState')
local PauseState = require('states.PauseState')
local GameOverState = require('states.GameOverState')
local InputHandler = require('core.InputHandler')

local GameState = {}
GameState.__index = GameState

function GameState.new()
    local self = setmetatable({}, GameState)
    self:init()
    return self
end

function GameState:init()
    self.states = {}
    self.currentState = nil
    self.currentStateName = ''
    self.input = InputHandler.new()
    
    self.states.menu = MenuState.new(self)
    self.states.play = PlayState.new(self)
    self.states.pause = PauseState.new(self)
    self.states.gameover = GameOverState.new(self)
    
    self.currentState = self.states.menu
    self.currentStateName = 'menu'
    self.currentState:enter()
end

function GameState:change(stateName, ...)
    if not self.states[stateName] then
        return false
    end
    
    local prevState = self.currentState
    self.currentState:exit()
    
    self.currentState = self.states[stateName]
    self.currentStateName = stateName
    
    local args = {...}
    if #args > 0 and self.currentState.enter then
        self.currentState:enter(unpack(args))
    elseif self.currentState.enter then
        self.currentState:enter(prevState)
    end
    
    return true
end

function GameState:update(dt)
    self.input:update(dt)
    if self.currentState.update then
        self.currentState:update(dt)
    end
end

function GameState:draw()
    if self.currentState.draw then
        self.currentState:draw()
    end
end

function GameState:keyPressed(key)
    if self.input:keyPressed(key) then
        if self.currentState.handleInput then
            self.currentState:handleInput(self.input)
        end
    end
end

function GameState:keyReleased(key)
    self.input:keyReleased(key)
end

function GameState:getCurrentState()
    return self.currentState
end

function GameState:getStateName()
    return self.currentStateName
end

return GameState