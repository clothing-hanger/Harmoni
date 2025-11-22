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