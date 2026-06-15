-- BoardRenderer: Handles all board drawing operations
local constants = require('lib.constants')

local BoardRenderer = {}
BoardRenderer.__index = BoardRenderer

function BoardRenderer.new()
    local self = setmetatable({}, BoardRenderer)
    self:init()
    return self
end

function BoardRenderer:init()
    self.cellSize = constants.BOARD.CELL_SIZE
    self.offsetX = constants.BOARD.OFFSET_X
    self.offsetY = constants.BOARD.OFFSET_Y
    self.gameFont = nil
end

function BoardRenderer:getFonts()
    if not self.gameFont then
        self.gameFont = love.graphics.newFont(16)
    end
    return self.gameFont
end

function BoardRenderer:drawBackground()
    love.graphics.setBackgroundColor(constants.BOARD_BACKGROUND or constants.COLORS.BACKGROUND)
end

function BoardRenderer:drawGrid(board)
    love.graphics.setColor(constants.COLORS.GRID_BORDER)
    love.graphics.rectangle('fill', self.offsetX - 2, self.offsetY - 2,
        constants.BOARD.COLS * self.cellSize + 4,
        constants.BOARD.ROWS * self.cellSize + 4, 2, 2)
    
    love.graphics.setColor(constants.COLORS.BACKGROUND)
    love.graphics.rectangle('fill', self.offsetX, self.offsetY,
        constants.BOARD.COLS * self.cellSize,
        constants.BOARD.ROWS * self.cellSize)
    
    love.graphics.setColor(constants.COLORS.GRID_LINE)
    for row = 1, constants.BOARD.ROWS do
        for col = 1, constants.BOARD.COLS do
            local x, y = board:getDrawPosition(row, col)
            love.graphics.rectangle('line', x, y, self.cellSize - 1, self.cellSize - 1)
            
            local color = board:getCell(row, col)
            if color then
                love.graphics.setColor(color)
                love.graphics.rectangle('fill', x + 1, y + 1, self.cellSize - 3, self.cellSize - 3, 2, 2)
            end
        end
    end
end

function BoardRenderer:drawPiece(piece)
    if not piece then return end
    
    love.graphics.setColor(piece.color)
    local matrix = piece:getMatrix()
    
    for r = 1, #matrix do
        for c = 1, #matrix[r] do
            if matrix[r][c] then
                local row = piece:getBoardRow() + r - 1
                local col = piece:getBoardCol() + c - 1
                local x, y = self:getCellPosition(row, col)
                love.graphics.rectangle('fill', x + 1, y + 1, self.cellSize - 3, self.cellSize - 3, 2, 2)
            end
        end
    end
end

function BoardRenderer:drawGhostPiece(piece, ghostRow)
    if not piece then return end
    
    local matrix = piece:getMatrix()
    love.graphics.setColor(1, 1, 1, 0.2)
    
    for r = 1, #matrix do
        for c = 1, #matrix[r] do
            if matrix[r][c] then
                local row = ghostRow + r - 1
                local col = piece:getBoardCol() + c - 1
                local x, y = self:getCellPosition(row, col)
                love.graphics.rectangle('line', x + 1, y + 1, self.cellSize - 3, self.cellSize - 3, 2, 2)
            end
        end
    end
end

function BoardRenderer:drawNextPiece(piece)
    local width = love.graphics.getWidth()
    local offsetX = width - 150
    
    self:getFonts()
    love.graphics.setFont(self.gameFont)
    love.graphics.setColor(constants.COLORS.TEXT)
    love.graphics.print('Next:', offsetX, 50)
    
    if piece then
        local cellSize = 25
        local matrix = piece:getMatrix()
        local startX = offsetX + 20
        local startY = 80
        
        love.graphics.setColor(piece.color)
        for r = 1, #matrix do
            for c = 1, #matrix[r] do
                if matrix[r][c] then
                    local x = startX + (c - 1) * cellSize
                    local y = startY + (r - 1) * cellSize
                    love.graphics.rectangle('fill', x, y, cellSize - 2, cellSize - 2, 2, 2)
                end
            end
        end
    end
end

function BoardRenderer:drawUI(score, level, linesCleared)
    local offsetX = self.offsetX + constants.BOARD.COLS * self.cellSize + 30
    
    self:getFonts()
    love.graphics.setFont(self.gameFont)
    love.graphics.setColor(constants.COLORS.TEXT)
    
    love.graphics.print('Score: ' .. score, offsetX, 50)
    love.graphics.print('Level: ' .. level, offsetX, 75)
    love.graphics.print('Lines: ' .. linesCleared, offsetX, 100)
    
    love.graphics.print('Controls:', offsetX, 160)
    love.graphics.print('Left/Right : Move', offsetX, 180)
    love.graphics.print('Up : Rotate', offsetX, 200)
    love.graphics.print('Space : Drop', offsetX, 220)
    love.graphics.print('P/Esc : Pause', offsetX, 240)
end

function BoardRenderer:getCellPosition(row, col)
    return self.offsetX + (col - 1) * self.cellSize,
           self.offsetY + (row - 1) * self.cellSize
end

return BoardRenderer