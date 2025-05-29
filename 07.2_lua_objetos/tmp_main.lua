-- Escribe codigo
require "library"
require "xml"
prepareWindow()

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
criaturas = {}
criaturasData = readXML("criaturas.xml")
---- Fin de tus variables globales

-- Define tus funciones y llamadas
function getChildValue(tag, key)
    for i = 1, #tag do
        if tag[i].tag == key then
            local raw = tag[i][1]
            if raw and type(raw) == "string" then
                return raw:match("^%s*(.-)%s*$")  -- trim
            end
        end
    end
    return nil
end


function getSize(tag)
    for i = 1, #tag do
        if tag[i].tag == "size" then
            local rawX = getChildValue(tag[i], "X")
            local rawY = getChildValue(tag[i], "Y")
            local x = tonumber(rawX)
            local y = tonumber(rawY)
            if x and y then
                return x, y
            end
        end
    end
    return 32, 32 -- valor por defecto
end


function cargarCriaturas()
    local posX = 0
    local posY = 0
    
    for i = 1, #criaturasData do
        local criatura = criaturasData[i]
        
        if criatura.tag == "criatura" then
            local name = getChildValue(criatura, "name")
            local texture = getChildValue(criatura, "texture")
            local sizeX, sizeY = getSize(criatura)

            --print("Cargando criatura:", name, texture, sizeX, sizeY)
            local prop = addImage(texture, posX, posY, sizeX, sizeY)
            criaturas[#criaturas+1] = { name = name, prop = prop }

            -- ajustamos las posiciones para no superponer
            posX = posX + sizeX + 10
            if posX > 900 then
                posX = 0
                posY = posY + sizeY + 10
            end
        end
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


cargarCriaturas()

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

