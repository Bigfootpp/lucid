local ContextManager = {}

local contexts = {}

function ContextManager.GetContext()
    return contexts[coroutine.running()]
end

function ContextManager.SetContext(ctx)
    contexts[coroutine.running()] = ctx
end

function ContextManager.BindContext(instance, method, ctx)
    return function(_, ...)
        local args = table.pack(instance, ...)

        local prev = ContextManager.GetContext()
        ContextManager.SetContext(ctx)
        
        local success, result = pcall(function()
           return table.pack(method(table.unpack(args, 1, args.n)))
        end)
        
        ContextManager.SetContext(prev)

        if not success then
            error(result)
        end
        
        return table.unpack(result, 1, result.n)
    end
end

return ContextManager