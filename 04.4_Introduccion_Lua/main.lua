-- Escribe codigo
require "library"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
enemies = {}
dmg = 5

-- Termina tu definicion de variables

function onUpdate(seconds)
end

function onClickLeft(down)
    print("Clicked Left")
    if not down then
        -- Escribe tu código para el botón izquierdo
        local griphonProp = addCreature("griphon", mousePositionX, mousePositionY)
        local griphonData = { griphonProp, 25 }
        table.insert(enemies, griphonData)
        -- Termina tu código
    end
end

function onClickRight(down)
    print("Clicked Right")
    creatureSizeX, creatureSizeY = getCreatureSize("griphon")
    if not down then
        -- Escribe tu código para el botón derecho
        for i = #enemies, 1, -1 do
            local enemy = enemies[i]
            local prop = enemy[1]
            local life = enemy[2]
            local posX, posY = getPropPosition(prop)
            
            
            if life > 0 then
                local posX, posY = getPropPosition(prop)
                
                if mousePositionX >= posX and mousePositionX <= posX + creatureSizeX and
                   mousePositionY >= posY and mousePositionY <= posY + creatureSizeY then
                   
                    enemy[2] = life - dmg
                    
                    if enemy[2] <= 0 then
                        removeCreature(prop)
                        table.remove(enemies, i)
                    end
                    
                    break
                end
            end
        end
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

