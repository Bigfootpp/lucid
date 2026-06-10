local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TypeUtils = require(ReplicatedStorage.Packages.LuCid.TypeUtils)
local TableUtil = {}

function TableUtil.Update<T, E>(target: T, extension: E, overwrite: boolean?): TypeUtils.Merge<T, E>
    if overwrite == nil then overwrite = true end
    assert(typeof(target) == "table", `Expected table for 'target', got '{typeof(target)}'`)
    assert(typeof(extension) == "table", `Expected table for 'extension', got '{typeof(extension)}'`)
    assert(typeof(overwrite) == "boolean", `Expected table for 'overwrite', got '{typeof(overwrite)}'`)

    for k, v in extension do
        if overwrite or target[k] == nil then
            target[k] = v
        end
    end

    return target 
end

function TableUtil.DeepCopy<T>(tbl: T): T
    assert(typeof(tbl) == "table", `Expected table for 'tbl', got '{typeof(tbl)}'`)
    
    local visited = {}

    local function deepCopy(original)
        if typeof(original) ~= "table" then
            return original
        end

        if visited[original] then
            return visited[original]
        end

        local clone = table.clone(original)
        visited[original] = clone

        for k, v in clone do
            if typeof(v) == "table" then
                clone[k] = deepCopy(v)
            end
        end

        return clone
    end

    return deepCopy(tbl)
end

return TableUtil