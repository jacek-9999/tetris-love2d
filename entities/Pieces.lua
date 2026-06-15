-- Piece factory: Creates all standard Tetris piece types
local Piece = require('entities.Piece')
local constants = require('lib.constants')

local Pieces = {}

Pieces.SHAPES = {
    I = {
        {0, 0, 0, 0},
        {1, 1, 1, 1},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
    },
    O = {
        {1, 1},
        {1, 1},
    },
    T = {
        {0, 1, 0},
        {1, 1, 1},
        {0, 0, 0},
    },
    S = {
        {0, 1, 1},
        {1, 1, 0},
        {0, 0, 0},
    },
    Z = {
        {1, 1, 0},
        {0, 1, 1},
        {0, 0, 0},
    },
    J = {
        {1, 0, 0},
        {1, 1, 1},
        {0, 0, 0},
    },
    L = {
        {0, 0, 1},
        {1, 1, 1},
        {0, 0, 0},
    },
}

Pieces.TYPES = {'I', 'O', 'T', 'S', 'Z', 'J', 'L'}

function Pieces.createRandom()
    local pieceType = Pieces.TYPES[math.random(#Pieces.TYPES)]
    return Pieces.create(pieceType)
end

function Pieces.create(pieceType)
    local shape = Pieces.SHAPES[pieceType]
    local color = constants.PIECES[pieceType]
    return Piece.new(shape, color)
end

function Pieces.getTypes()
    return Pieces.TYPES
end

function Pieces.getShapes()
    return Pieces.SHAPES
end

return Pieces