local Class = {}
Class.__index = Class

type ClassType = {
    name: string | nil
}

export type ClassObject = typeof(setmetatable({} :: ClassType, Class))

function Class.New(): ClassObject 
    local self = setmetatable({}::ClassType, Class)

    return self
end

return Class