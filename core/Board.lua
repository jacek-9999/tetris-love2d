-- Board class: Manages the game grid where pieces fall
local constants = require('lib.constants')

local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({}, Board)
    self:init()
    return self
end

function Board:init()
    self.cols = constants.BOARD.COLS
    self.rows = constants.BOARD.ROWS
    self.grid = {}
    
    for row = 1, self.rows do
        self.grid[row] = {}
        for col = 1, self.cols do
            self.grid[row][col] = nil
        end
    end
end

function Board:isValidPosition(row, col)
    return row >= 1 and row <= self.rows and col >= 1 and col <= self.cols
end

function Board:isCellEmpty(row, col)
    if not self:isValidPosition(row, col) then
        return false
    end
    return self.grid[row][col] == nil
end

function Board:setCell(row, col, color)
    if self:isValidPosition(row, col) then
        self.grid[row][col] = color
    end
end

function Board:getCell(row, col)
    if self:isValidPosition(row, col) then
        return self.grid[row][col]
    end
    return nil
end

function Board:lockPiece(piece)
    local matrix = piece:getMatrix()
    local baseRow = piece:getBoardRow()
    local baseCol = piece:getBoardCol()
    
    for r = 1, #matrix do
        for c = 1, #matrix[r] do
            if matrix[r][c] then
                local row = baseRow + r - 1
                local col = baseCol + c - 1
                if self:isValidPosition(row, col) then
                    self.grid[row][col] = piece.color
                end
            end
        end
    end
end

function Board:checkLineFull(row)
    for col = 1, self.cols do
        if self.grid[row][col] == nil then
            return false
        end
    end
    return true
end

function Board:clearLines()
    local linesCleared = 0
    local row = self.rows
    
    while row >= 1 do
        if self:checkLineFull(row) then
            linesCleared = linesCleared + 1
            table.remove(self.grid, row)
            local newRow = {}
            for col = 1, self.cols do
                newRow[col] = nil
            end
            table.insert(self.grid, 1, newRow)
        else
            row = row - 1
        end
    end
    
    return linesCleared
end

function Board:isGameOver()
    for col = 1, self.cols do
        if self.grid[1][col] ~= nil then
            return true
        end
    end
    return false
end

function Board:clear()
    self:init()
end

function Board:getDrawPosition(row, col)
    local cellSize = constants.BOARD.CELL_SIZE
    local offsetX = constants.BOARD.OFFSET_X
    local offsetY = constants.BOARD.OFFSET_Y
    
    return offsetX + (col - 1) * cellSize,
           offsetY + (row - 1) * cellSize
end

return Board