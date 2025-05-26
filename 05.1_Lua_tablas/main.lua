-- Escribe codigo
require "library"
require "prepare"

-- Define tus variables globales
-- Termina tu definicion de variables

function pintarPunto(punto)
    -- Rellenar c�digo para pintar un punto en la pantalla
    drawPoint(punto.x, punto.y)
    -- Fin de c�digo
end

function onUpdate(seconds)
end

function onDraw()
    -- Empieza tu c�digo, que debe emplear la funcion pintarPunto
    local square_size = 50
    local start_x = 100
    local start_y = 100
    
    for x = start_x, start_x + square_size do
        for y = start_y, start_y + square_size do
            pintarPunto({x = x, y = y})
        end
    end
    -- Termina tu c�digo
end

function onClickLeft(down)
    print("Clicked Left")
    if down then
    end
end

function onClickRight(down)
    print("Clicked Right")
    if down then
    end
end


function onMouseMove(posX, posY)
    --print("Mouse Moved to " .. posX .. ","..posY)
end

function onKeyPress(key, down)
    print("Key pressed: "..key)
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress, onDraw, window_layer)
mainLoop()

