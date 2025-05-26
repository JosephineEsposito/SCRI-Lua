-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
creature_texture_map = {
    ["Grifo"] = "creatures/gryphon.png",
    ["Mago"] = "creatures/mage.png",
    ["Grunt"] = "creatures/grunt.png",
    ["Peon"] = "creatures/peon.png",
    ["Dragon"] = "creatures/dragon.png",
}    
-- Fin de tus variables globales

-- Define tus funciones y llamadas
function addCreature(creature_name, position_x, position_y)
    local image_name = creature_texture_map[creature_name]
    if image_name then
        return addImage(image_name, position_x, position_y, 64, 64)
    else
        print("Error: creature name '" .. creature_name .. "' not found in the local map.")
        return nil
    end
end
-- Fin de tus funciones

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    if not down then
        -- Escribe tu código para el botón derecho
        -- Termina tu código
    end
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end

addCreature("Dragon", 200, 200) -- Dragon at (200, 200)
addCreature("Grifo", 400, 200)  -- Gryphon at (400, 200)
addCreature("Mago", 600, 200)   -- Mage at (600, 200)
addCreature("Grunt", 100, 400)  -- Grunt at (100, 400)
addCreature("Peon", 300, 400)   -- Peon at (300, 400)

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

