-- Base State class: Abstract base for all game states
local State = {}
State.__index = State

function State.new(stateMachine)
    local self = setmetatable({}, State)
    self.stateMachine = stateMachine
    return self
end

function State:enter() end
function State:exit() end
function State:update(dt) end
function State:draw() end
function State:handleInput(input) end

return State