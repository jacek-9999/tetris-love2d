-- Utility functions for the game

local M = {}

function M.hexToRgb(hex)
    local r = tonumber(string.sub(hex, 1, 2), 16) / 255
    local g = tonumber(string.sub(hex, 3, 4), 16) / 255
    local b = tonumber(string.sub(hex, 5, 6), 16) / 255
    return r, g, b, 1
end

function M.deepCopy(orig)
    if type(orig) ~= 'table' then return orig end
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = M.deepCopy(v)
    end
    return copy
end

function M.rotateMatrix(matrix, direction)
    local rows = #matrix
    local cols = #matrix[1] or 0
    local result = {}
    
    if direction == 1 then
        for i = 1, cols do
            result[i] = {}
            for j = 1, rows do
                result[i][j] = matrix[rows - j + 1][i]
            end
        end
    else
        for i = 1, cols do
            result[i] = {}
            for j = 1, rows do
                result[i][j] = matrix[j][cols - i + 1]
            end
        end
    end
    
    return result
end

function M.round(x)
    return math.floor(x + 0.5)
end

function M.clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

return M