--!strict
local Class = require(script.Class)

local function class(methods)
    return Class.New(methods)
end

return class