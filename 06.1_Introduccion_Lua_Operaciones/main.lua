-- Escribe codigo
require "library"
print("Library loaded")

prepareWindow()
print("Window prepared")

creature = drawCreature(layer, "griphon", 256, 256)
print("Creature drawn")

function onUpdate(seconds)
    print("onUpdate called")
    creaturePositionX, creaturePositionY = getPropPosition(creature)
    
    -- Empieza tu código
    --creaturePositionX = creaturePositionX + (10 * seconds)
    creaturePositionX = creaturePositionX - (10 * seconds)
    -- Termina tu código
    
    setPropPosition(creature, creaturePositionX, creaturePositionY)
end

function onClickLeft(down)
    print("Clicked Left")
end

function onClickRight(down)
    print("Clicked Right")
end

function onMouseMove(posX, posY)
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



print("Setting callbacks")
callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
print("Callbacks set")

mainLoop()
print("Main loop started")

