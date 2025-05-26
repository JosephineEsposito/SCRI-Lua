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
function addCreature(creature_name)
    local image_name = creature_texture_map[creature_name]
    if image_name then
        return addImage(image_name, 100, 100, 64, 64)
    else
        print("Error: creature name '" .. creature_name .. "' not found in the local map.")
        return nil
    end
end
-- Fin de tus funciones

addCreature("Dragon")


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



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

