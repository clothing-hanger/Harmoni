local profiler = {}

profiler.__records = {}

function profiler:start(id)
    assert(id ~= nil and id ~= "", "ID for profiler:start is required")
    if not self.__records[id] then
        self.__records[id] = {
            _records = {},
            _average = 0,
            _startTime = 0,
            _endTime = 0,
        }
    end

    self.__records[id]._startTime = love.timer.getTime()
end

function profiler:stop(id)
    assert(id ~= nil and id ~= "", "ID for profiler:stop is required")
    assert(self.__records[id] ~= nil, "No record for " .. id .. " was found.")

    local rec = self.__records[id]
    rec._endTime = love.timer.getTime()
    table.insert(rec._records, rec._endTime - rec._startTime)

    local count = #rec._records
    local total = 0
    for _, v in ipairs(rec._records) do
        total = total + v
    end
    rec._average = total / count
end

function profiler:getAverage(id)
    assert(id ~= nil and id ~= "", "ID for profiler:stop is required")
    assert(self.__records[id] ~= nil, "No record for " .. id .. " was found.")

    return self.__records[id]._average * 1000
end

function profiler:getLastTime(id)
    assert(id ~= nil and id ~= "", "ID for profiler:stop is required")
    assert(self.__records[id] ~= nil, "No record for " .. id .. " was found.")

    local rec = self.__records[id]
    return (rec._endTime - rec._startTime) * 1000
end

return profiler
