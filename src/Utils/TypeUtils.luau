export type function Merge(tblA, tblB)
    assert(tblA.tag == "table", "First argument need to be a table")
    assert(tblB.tag == "table", "Second argument need to be a table")

    local bProps = tblB:properties()
    if next(bProps) == nil then
        return tblA
    end

    local aProps = tblA:properties()
    if next(aProps) == nil then
        return tblB
    end

    local mergedProps = {}
    for k, v in aProps do
        mergedProps[k] = v
    end
    for k, v in bProps do
        mergedProps[k] = v.write or v.read
    end

    local indexer = tblB:indexer() or tblA:indexer()
    local metatable = tblB:metatable() or tblA:metatable()

    return types.newtable(mergedProps, indexer, metatable)
end

export type function Clean(tbl)
    if tbl.tag ~= "table" then
        return tbl
    end

    local props = tbl:properties()
    if next(props) == nil then
        return types.newtable()
    end

    local cleanProps = {}
    for keyType, valueTypes in props do
        cleanProps[keyType] = valueTypes.write or valueTypes.read
    end

    return types.newtable(cleanProps)
end

export type function Unseal(tbl)
    if tbl.tag ~= "table" then
        return tbl
    end
    
    local props = tbl:properties()
    local newProps = {}
    for name, prop in props do
        newProps[name] = prop.read
    end
    
    local indexer = {
        index = types.string,
        readresult = types.any,
        writeresult = types.any
    }
    
    return types.newtable(newProps, indexer, tbl:metatable())
end

export type function DeepUnseal(tbl)
    local visited = {}

    local function unsealImpl(ty)
        local tag = ty.tag
        if tag == "union" then
            local components = {}
            for i, component in ipairs(ty:components()) do
                components[i] = unsealImpl(component)
            end
            return types.unionof(unpack(components))
        end

        if tag ~= "table" then
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
                newTable:setproperty(key, unsealImpl(propType))
            end
        end
        
        newTable:setindexer(types.string, types.any)
        
        return newTable
    end
    
    if tbl.tag ~= "table" then
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