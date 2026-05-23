--!strict
local Class = require(script.Class)

local function class(methods: {}): Class.ClassObject
    return Class.New(methods)
end

return class