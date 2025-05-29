local vector = require "vector"

local v1 = vector.new(2, 4)
local v2 = vector.new(3, 6)

local sum = v1:add(v2)
local diff = v1:sub(v2)
local dot = v1:dot(v2)
local len = v1:length()
local norm = v1:normalize()
local scaled = v1:scale(2)

print("sum:", sum:print())
print("diff:", diff:print())
print("dot:", dot)
print("length of v1:", len)
print("normalized v1:", norm:print())
print("scaled v1 * 2:", scaled:print())
