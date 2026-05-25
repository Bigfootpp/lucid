--!strict
local Class = require(script.Class)

local function class(variables)
    return function(methods)
        return Class.New(variables, methods)
    end
end

return class