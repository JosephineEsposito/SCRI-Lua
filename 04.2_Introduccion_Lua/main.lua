-- Escribe codigo
require "library"
prepareWindow()

creature = drawCreature(layer, "griphon", 256, 256)
mousePositionX = 0
mousePositionY = 0

count = 1

function onUpdate(seconds)
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    -- Empieza tu c�digo para mover a la criatura
    local delta = 10 * seconds
    if count == 1 then
        creaturePositionX = creaturePositionX + delta
    end
    if count == 2 then
        creaturePositionY = creaturePositionY + delta
    end
    if count == 3 then
        creaturePositionX = creaturePositionX - delta
    end
    if count == 4 then
        creaturePositionY = creaturePositionY - delta
    end
    -- Termina tu c�digo
    setPropPosition(creature, creaturePositionX, creaturePositionY)
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
        creatureSizeX, creatureSizeY = getCreatureSize("griphon")
        creaturePositionX, creaturePositionY = getPropPosition(creature)
        -- Escribe tu c�digo aqui para bot�n izquierdo rat�n
        count = count + 1
        if count > 4 then
            count = 0
        end
        -- Termina tu c�digo
    end
end

function onClickRight(down)
    print("Clicked Right")
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

