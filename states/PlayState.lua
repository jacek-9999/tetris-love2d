-- PlayState: Main gameplay state
local State = require('states.State')
local Board = require('core.Board')
local BoardRenderer = require('core.BoardRenderer')
local Pieces = require('entities.Pieces')
local constants = require('lib.constants')

local PlayState = setmetatable({}, {__index = State})
PlayState.__index = PlayState

function PlayState.new(stateMachine)
    local self = setmetatable(State.new(stateMachine), PlayState)
    self:init()
    return self
end

function PlayState:init()
    self.board = nil
    self.currentPiece = nil
    self.nextPiece = nil
    self.score = 0
    self.level = 1
    self.linesCleared = 0
    self.dropTimer = 0
    self.dropInterval = constants.GAME.INITIAL_DROP_INTERVAL
    self.lockTimer = 0
    self.isLocking = false
    self.isGameOver = false
    self.renderer = BoardRenderer.new()
end

function PlayState:enter()
    self.board = Board.new()
    self.score = 0
    self.level = 1
    self.linesCleared = 0
    self.dropInterval = constants.GAME.INITIAL_DROP_INTERVAL
    self.dropTimer = 0
    self.lockTimer = 0
    self.isLocking = false
    self.isGameOver = false
    
    self.currentPiece = Pieces.createRandom()
    self.currentPiece:setBoardPosition(0, 3)
    self.nextPiece = Pieces.createRandom()
end

function PlayState:update(dt)
    if self.isGameOver then return end
    self:handleMovement()
    self:handleDrop(dt)
    self:handleLocking()
end

function PlayState:handleMovement()
    local input = self.stateMachine.input
    
    if input:justPressed('left') or input:justPressed('a') then
        self:movePiece(-1, 0)
    elseif input:justPressed('right') or input:justPressed('d') then
        self:movePiece(1, 0)
    elseif input:justPressed('up') or input:justPressed('w') then
        self:rotatePiece(1)
    elseif input:justPressed('x') then
        self:rotatePiece(-1)
    elseif input:justPressed('space') then
        self:hardDrop()
    elseif input:justPressed('escape') or input:justPressed('p') then
        self.stateMachine:change('pause')
    end
end

function PlayState:handleDrop(dt)
    self.dropTimer = self.dropTimer + dt
    local isDown = love.keyboard.isDown('down') or love.keyboard.isDown('s')
    local interval = isDown and constants.GAME.FAST_DROP_INTERVAL or self.dropInterval
    
    if self.dropTimer >= interval then
        self.dropTimer = 0
        self:dropPiece()
    end
end

function PlayState:handleLocking()
    if self.isLocking and self.lockTimer >= constants.GAME.LOCK_DELAY then
        self:lockPiece()
    end
end

function PlayState:movePiece(dCol, dRow)
    self.currentPiece:move(dRow, dCol)
    if not self.currentPiece:isValidPosition(self.board) then
        self.currentPiece:move(-dRow, -dCol)
        return false
    end
    return true
end

function PlayState:rotatePiece(direction)
    local rotated = self.currentPiece:rotate(self.board, direction)
    if rotated and self.isLocking then
        self.lockTimer = 0
    end
    return rotated
end

function PlayState:dropPiece()
    if self.isLocking then return end
    
    if not self:movePiece(0, 1) then
        self.isLocking = true
        self.lockTimer = 0
    end
end

function PlayState:hardDrop()
    local dropDistance = 0
    while self:movePiece(0, 1) do
        dropDistance = dropDistance + 1
    end
    self.score = self.score + dropDistance * 2
    self:lockPiece()
end

function PlayState:lockPiece()
    self.board:lockPiece(self.currentPiece)
    self:processLines()
    self:spawnNextPiece()
    
    if not self.currentPiece:isValidPosition(self.board) then
        self.isGameOver = true
        self.stateMachine:change('gameover')
    end
end

function PlayState:processLines()
    local lines = self.board:clearLines()
    if lines > 0 then
        self.linesCleared = self.linesCleared + lines
        self.score = self.score + constants.GAME.POINTS[lines] * self.level
        self:checkLevelUp()
    end
end

function PlayState:checkLevelUp()
    local newLevel = math.floor(self.linesCleared / constants.GAME.LINES_PER_LEVEL) + 1
    if newLevel > self.level then
        self.level = newLevel
        self.dropInterval = constants.GAME.INITIAL_DROP_INTERVAL / (1 + (self.level - 1) * 0.15)
    end
end

function PlayState:spawnNextPiece()
    self.currentPiece = self.nextPiece
    self.currentPiece:setBoardPosition(0, 3)
    self.nextPiece = Pieces.createRandom()
    self.isLocking = false
    self.lockTimer = 0
end

function PlayState:draw()
    self.renderer:drawBackground()
    self.renderer:drawGrid(self.board)
    self.renderer:drawGhostPiece(self.currentPiece, self.currentPiece:getGhostPosition(self.board))
    self.renderer:drawPiece(self.currentPiece)
    self.renderer:drawNextPiece(self.nextPiece)
    self.renderer:drawUI(self.score, self.level, self.linesCleared)
end

return PlayState