-- super_expanta.lua
-- SuperExpantaNum and BashicuMatrix implementation for Balatro
-- Author: Hallowing

-- SuperExpantaNum Class
SuperExpantaNum = {}
SuperExpantaNum.__index = SuperExpantaNum

function SuperExpantaNum:new(value)
    local obj = {}
    setmetatable(obj, SuperExpantaNum)
    if type(value) == "number" then
        obj.value = value
        obj.matrix = nil
    elseif type(value) == "table" and value.__type == "BashicuMatrix" then
        obj.value = nil
        obj.matrix = value
    else
        error("Invalid value for SuperExpantaNum")
    end
    return obj
end

function SuperExpantaNum:add(other)
    if self.matrix or other.matrix then
        local aMatrix = self:toMatrix()
        local bMatrix = other:toMatrix()
        return SuperExpantaNum:new(aMatrix:add(bMatrix))
    else
        return SuperExpantaNum:new(self.value + other.value)
    end
end

function SuperExpantaNum:mul(other)
    if self.matrix or other.matrix then
        local aMatrix = self:toMatrix()
        local bMatrix = other:toMatrix()
        return SuperExpantaNum:new(aMatrix:mul(bMatrix))
    else
        return SuperExpantaNum:new(self.value * other.value)
    end
end

function SuperExpantaNum:pow(other)
    if self.matrix or other.matrix then
        local aMatrix = self:toMatrix()
        local bMatrix = other:toMatrix()
        return SuperExpantaNum:new(aMatrix:pow(bMatrix))
    else
        return SuperExpantaNum:new(self.value ^ other.value)
    end
end

function SuperExpantaNum:toMatrix()
    if self.matrix then
        return self.matrix
    else
        return BashicuMatrix:fromValue(self.value)
    end
end

function SuperExpantaNum:toString()
    if self.matrix then
        return self.matrix:toString()
    else
        return tostring(self.value)
    end
end

function SuperExpantaNum:toNumber()
    if self.matrix then
        return self.matrix:value()
    else
        return self.value
    end
end

-- BashicuMatrix Class
BashicuMatrix = {}
BashicuMatrix.__index = BashicuMatrix
BashicuMatrix.__type = "BashicuMatrix"

function BashicuMatrix:new(matrix)
    local obj = {}
    setmetatable(obj, BashicuMatrix)
    obj.matrix = matrix or {}
    return obj
end

function BashicuMatrix:fromValue(value)
    return BashicuMatrix:new({{value}})
end

function BashicuMatrix:value()
    local total = 0
    for i = 1, #self.matrix do
        for j = 1, #self.matrix[i] do
            local cell = self.matrix[i][j]
            if type(cell) == "table" and cell.__type == "BashicuMatrix" then
                total = total + cell:value()
            else
                total = total + cell
            end
        end
    end
    return total
end

function BashicuMatrix:add(other)
    local result = {}
    for i = 1, math.max(#self.matrix, #other.matrix) do
        result[i] = {}
        for j = 1, math.max(#(self.matrix[i] or {}), #(other.matrix[i] or {})) do
            local a = self.matrix[i] and self.matrix[i][j] or 0
            local b = other.matrix[i] and other.matrix[i][j] or 0
            if type(a) == "table" and a.__type == "BashicuMatrix" and
               type(b) == "table" and b.__type == "BashicuMatrix" then
                result[i][j] = a:add(b)
            else
                result[i][j] = (type(a) == "number" and a or 0) + (type(b) == "number" and b or 0)
            end
        end
    end
    return BashicuMatrix:new(result)
end

function BashicuMatrix:mul(other)
    local result = {}
    for i = 1, math.max(#self.matrix, #other.matrix) do
        result[i] = {}
        for j = 1, math.max(#(self.matrix[i] or {}), #(other.matrix[i] or {})) do
            local a = self.matrix[i] and self.matrix[i][j] or 1
            local b = other.matrix[i] and other.matrix[i][j] or 1
            if type(a) == "table" and a.__type == "BashicuMatrix" and
               type(b) == "table" and b.__type == "BashicuMatrix" then
                result[i][j] = a:mul(b)
            else
                result[i][j] = (type(a) == "number" and a or 1) * (type(b) == "number" and b or 1)
            end
        end
    end
    return BashicuMatrix:new(result)
end

function BashicuMatrix:pow(other)
    local result = {}
    for i = 1, math.max(#self.matrix, #other.matrix) do
        result[i] = {}
        for j = 1, math.max(#(self.matrix[i] or {}), #(other.matrix[i] or {})) do
            local a = self.matrix[i] and self.matrix[i][j] or 1
            local b = other.matrix[i] and other.matrix[i][j] or 1
            if type(a) == "table" and a.__type == "BashicuMatrix" and
               type(b) == "table" and b.__type == "BashicuMatrix" then
                result[i][j] = a:pow(b)
            else
                result[i][j] = (type(a) == "number" and a or 1) ^ (type(b) == "number" and b or 1)
            end
        end
    end
    return BashicuMatrix:new(result)
end

function BashicuMatrix:toString()
    local rows = {}
    for i = 1, #self.matrix do
        local row = {}
        for j = 1, #self.matrix[i] do
            local cell = self.matrix[i][j]
            if type(cell) == "table" and cell.__type == "BashicuMatrix" then
                table.insert(row, "{" .. cell:toString() .. "}")
            else
                table.insert(row, tostring(cell))
            end
        end
        table.insert(rows, table.concat(row, ", "))
    end
    return table.concat(rows, "\n")
end