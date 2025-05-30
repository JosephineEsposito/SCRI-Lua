-- Escribe codigo
require "library"
sequences = require "sequence"
table.unpack = table.unpack or unpack
window_layer, debug_layer = prepareWindow()

--mySequence = sequences.Sequence:new()

worldSizeX = 1024
worldSizeY = 768

mousePositionX = nil
mousePositionY = nil

-- Define tus variables globales
enemies = {}

criaturas = {
    grifo = { texture = "creatures/gryphon.png", size = {x = 92, y = 92}},
    mago = { texture = "creatures/mage.png", size = {x = 64, y = 64}},
    grunt = { texture = "creatures/grunt.png", size = {x = 72, y = 72}},
    peon = { texture = "creatures/peon.png", size = {x = 32, y = 32}},
    dragon = { texture = "creatures/dragon.png", size = {x = 128, y = 128}},
}
mapa = {
    {
        name = "grifo",
        position = { x = 200, y = 100},
    },
    {
        name = "mago",
        position = { x = 100, y = 200},
    },
    {
        name = "peon",
        position = { x = 400, y = 100},
    },
    {
        name = "dragon",
        position = { x = 400, y = 400},
    },
}

creatureNames = {}
for name, _ in pairs(criaturas) do
    table.insert(creatureNames, name)
end
-- Fin de tus variables globales

-- Define tus funciones

function addCreature(creature_name, posX, posY)
    local creature_data = criaturas[creature_name]
    
    if creature_data then
        local texture_path = creature_data.texture
        local size_x = creature_data.size.x
        local size_y = creature_data.size.y
        
        return addImage(texture_path, posX, posY, size_x, size_y)
    else
        print("Error: creature '" .. creature_name .. "' not found.")
        return nil
    end
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

creatureCoroutine = nil

function createCreatureGenerator()
    local shuffled = {table.unpack(creatureNames)}
    shuffle(shuffled)
    
    return coroutine.create(function()
        for _, name in ipairs(shuffled) do
            coroutine.yield(name)
        end
    end)
end

-- Fin de tus funciones



function onDraw()
    -- Escribe tu código para pintar pixel a pixel
    
    -- Fin de tu código
end

function onUpdate(seconds)
    -- Escribe tu código para ejecutar cada frame
    -- Fin del código
end

function onClickLeft(down)
    -- Escribe tu código para el click del ratón izquierdo (down será true si se ha pulsado, false si se ha soltado)
    if down then
    if not creatureCoroutine or coroutine.status(creatureCoroutine) == "dead" then
        creatureCoroutine = createCreatureGenerator()
    end

    local success, creatureName = coroutine.resume(creatureCoroutine)
    if success and creatureName then
        local enemyProp = addCreature(creatureName, mousePositionX, mousePositionY)
        table.insert(enemies, enemyProp)
    elseif not creatureName then
        print("All creatures have been placed. Restart the coroutine with a click.")
    end
end
    -- Fin del código
end

function onClickRight(down)
    -- Escribe tu código para el click del ratón derecho (down será true si se ha pulsado, false si se ha soltado)
    if down then
    
    end
    -- Fin del código
end

function onMouseMove(posX, posY)
    mousePositionX = posX
    mousePositionY = posY
    -- Escribe tu código cuando el ratón se mueve
    
    -- Fin del código
end

function onKeyPress(key, down)
    -- Escribe tu código para tecla pulsada (down será true si la tecla se ha pulsado, false si se ha soltado)
    
    -- Fin del código
end

callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, debug_layer)
mainLoop()

