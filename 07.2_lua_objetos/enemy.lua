-- enemy.lua
require "library"
local vector = require "vector"

Enemigo = {}
Enemigo.__index = Enemigo

function Enemigo.new(prop, texture, x, y, width, height)
    local self = setmetatable({}, Enemigo)
    self.position = vector.new(x, y)
    self.size = vector.new(width, height)
    self.maxVida = 100
    self.vida = self.maxVida
    self.prop = prop
    return self
end

function Enemigo:isClicked(mouseX, mouseY)
    return mouseX >= self.position.x and mouseX <= self.position.x + self.size.x and
           mouseY >= self.position.y and mouseY <= self.position.y + self.size.y
end


function Enemigo:takeDamage(amount)
    self.vida = self.vida - amount
    if self.vida <= 0 then
        self:die()
    end
end

function Enemigo:die()
    if self.prop then
        removeImage(self.prop)
        self.prop = nil
    end
    self.isDead = true
end

EnemigoHuidizo = setmetatable({}, { __index = Enemigo })
EnemigoHuidizo.__index = EnemigoHuidizo

function EnemigoHuidizo.new(prop, texture, x, y, width, height)
    local self = setmetatable(Enemigo.new(prop, texture, x, y, width, height), EnemigoHuidizo)
    return self
end

function EnemigoHuidizo:takeDamage(amount)
    self.vida = self.vida - amount
    if self.vida <= 0 then
        self:die()
    elseif self.vida < self.maxVida / 2 then
        self:moveRandomly()
    end
end

function EnemigoHuidizo:moveRandomly()
    local newX = math.random(0, 800)
    local newY = math.random(0, 600)
    self.position = vector.new(newX, newY)
    if self.prop then
        setPropPosition(self.prop, newX, newY)
    end
end