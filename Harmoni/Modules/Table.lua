function table.randomize(table)
    local newTable = {}
    for i = 1, #table do
        local rand = love.math.random(1, #table)
        table[i], table[rand] = table[rand], table[i]
    end
    return table
end