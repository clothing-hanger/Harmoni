function table.clone(t, deep)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        if deep and type(v) == "table" then
            copy[k] = table.clone(v, true)
        else
            copy[k] = v
        end
    end
    return copy
end

function table.isarray(t)
    if type(t) ~= "table" then return false end
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
        if type(k) ~= "number" or k < 1 or k > count or math.floor(k) ~= k then
            return false
        end
    end
    return true
end

function table.nkeys(t)
    if type(t) ~= "table" then return 0 end
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end
