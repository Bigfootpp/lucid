export type function Merge(tblA, tblB)
    assert(tblA:is("table"), "First argument need to be a table")
    assert(tblB:is("table"), "Second argument need to be a table")

    local result = types.copy(tblA)
    
    for keyType, valueTypes in tblB:properties() do
        local valueType = valueTypes.write or valueTypes.read
        
        result:setproperty(keyType, valueType)
    end
    
    return result
end

export type function Clean(tbl)
    if not tbl:is("table") then
        return tbl
    end

    local cleanTable = types.newtable()

    for keyType, valueTypes in tbl:properties() do
        local valueType = valueTypes.write or valueTypes.read
        cleanTable:setproperty(keyType, valueType)
    end

    return cleanTable
end

export type function Unseal(tbl)
    if not tbl:is("table") then
        return tbl
    end
    
    local newTable = types.newtable()
    
    for name, prop in tbl:properties() do
        newTable:setproperty(name, prop.read)
    end
    
    newTable:setindexer(types.string, types.any)
    
    return newTable
end

export type function DeepUnseal(tbl)
    local visited = {}

    local function unsealImpl(ty)
        if ty:is("union") then
            local components = {}
            for _, component in ipairs(ty:components()) do
                table.insert(components, unsealImpl(component))
            end
            return types.unionof(unpack(components))
        end

        if not ty:is("table") then
            return ty
        end
        
        if visited[ty] then
            return visited[ty]
        end
        
        local newTable = types.newtable()
        visited[ty] = newTable
        
        for key, prop in ty:properties() do
            local propType = prop.read
            if propType then
                local unsealedPropType = unsealImpl(propType)
                newTable:setproperty(key, unsealedPropType)
            end
        end
        
        newTable:setindexer(types.string, types.any)
        
        return newTable
    end
    
    if not tbl:is("table") then
        return tbl
    end
    
    return unsealImpl(tbl)
end

export type function Extend(tblA, tblB)
    assert(tblA:is("table"), "First argument need to be a table")
    assert(tblB:is("table"), "Second argument need to be a table")

    local result = types.copy(tblA)
    
    local idxA = tblA:readindexer()
    local idxB = tblB:readindexer()
    
    if idxA and idxB then
        result:setindexer(idxA.index, types.unionof(idxA.result, idxB.result))
    elseif idxB then
        result:setindexer(idxB.index, idxB.result)
    end
    
    return result
end

return {}