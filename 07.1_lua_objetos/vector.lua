local vector = {}
vector.__index = vector

function vector.new(x, y)
    local self = setmetatable({}, vector)
    self.x = x or 0
    self.y = y or 0
    return self
end

function vector:add(a)
    return vector.new(self.x + a.x, self.y + a.y)
end

function vector:sub(a)
    return vector.new(self.x - a.x, self.y - a.y)
end

function vector:dot(a)
    return self.x * a.x + self.y * a.y
end

function vector:length()
    return math.sqrt(self.x^2 + self.y^2)
end

function vector:normalize()
    local len = self:length()
    if len == 0 then
        return vector.new(0, 0)
    end
    return vector.new(self.x / len, self.y / len)
end

function vector:scale(a)
    return vector.new(self.x * a, self.y * a)
end

function vector:print()
    return string.format("Vector(%.2f, %.2f)", self.x, self.y)
end

return vector
