-- Base Piece class: Abstract representation of a Tetris piece
local utils = require('lib.utils')

local Piece = {}
Piece.__index = Piece

function Piece.new(shape, color)
    local self = setmetatable({}, Piece)
    self:init(shape, color)
    return self
end

function Piece:init(shape, color)
    self.color = color
    self:setShape(shape)
    self.boardRow = 0
    self.boardCol = 4
    self.rotation = 1
end

function Piece:setShape(shape)
    self.originalShape = shape
    self.shape = utils.deepCopy(shape)
    self.matrix = shape
end

function Piece:getMatrix()
    return self.matrix
end

function Piece:getBoardRow()
    return self.boardRow
end

function Piece:getBoardCol()
    return self.boardCol
end

function Piece:setBoardPosition(row, col)
    self.boardRow = row
    self.boardCol = col
end

function Piece:move(dRow, dCol)
    self.boardRow = self.boardRow + dRow
    self.boardCol = self.boardCol + dCol
end

function Piece:rotate(board, direction)
    local newMatrix = utils.rotateMatrix(self.matrix, direction)
    local oldMatrix = self.matrix
    
    self.matrix = newMatrix
    self.rotation = self.rotation + direction
    
    if self.rotation > 4 then self.rotation = 1 end
    if self.rotation < 1 then self.rotation = 4 end
    
    if not self:isValidPosition(board) then
        self.matrix = oldMatrix
        self.rotation = self.rotation - direction
        if self.rotation > 4 then self.rotation = 1 end
        if self.rotation < 1 then self.rotation = 4 end
        return false
    end
    
    return true
end

function Piece:isValidPosition(board, allowPartialSpawn)
    local minRow = allowPartialSpawn and -1 or 0
    for r = 1, #self.matrix do
        for c = 1, #self.matrix[r] do
            if self.matrix[r][c] then
                local row = self.boardRow + r - 1
                local col = self.boardCol + c - 1
                if row < minRow or row > board.height or col < 0 or col >= board.width then
                    return false
                end
                if row >= 0 and not board:isCellEmpty(row, col) then
                    return false
                end
            end
        end
    end
    return true
end

function Piece:getGhostPosition(board)
    local ghostRow = self.boardRow
    while true do
        local nextRow = ghostRow + 1
        local canMove = true
        
        for r = 1, #self.matrix do
            for c = 1, #self.matrix[r] do
                if self.matrix[r][c] then
                    local row = nextRow + r - 1
                    local col = self.boardCol + c - 1
                    if not board:isCellEmpty(row, col) then
                        canMove = false
                        break
                    end
                end
            end
            if not canMove then break end
        end
        
        if not canMove then break end
        ghostRow = nextRow
    end
    
    return ghostRow
end

return Piece