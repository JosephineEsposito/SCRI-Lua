-- Escribe codigo
require "library"
prepareWindow()

carta, carta_image = drawImage(layer, "cards\\A_C.png", 256, 256, 79, 123)
mousePositionX = 0
mousePositionY = 0

path = "cards\\"    -- the path of the cards
deli = "_"          -- the delimiter
type = ".png"       -- the file type

-- c as corazones, d as diamantes, t as treboles, p as picas
current_seed = "C"
current_key = "A"

function onUpdate(seconds)
end

function onClickLeft(down)
    if down then
        print("Clicked Left")
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
    image_file = nil
    key_pressed = convertKeyToChar(key)
    -- print("Key pressed: ", key_pressed)
    
    -- Escribe tu código para gestion de teclado
    if key_pressed == "c" or key_pressed == "C" then
        current_seed = "C"
    end
    if key_pressed == "d" or key_pressed == "D" then
        current_seed = "D"
    end
    if key_pressed == "t" or key_pressed == "T" then
        current_seed = "T"
    end
    if key_pressed == "p" or key_pressed == "P" then
        current_seed = "P"
    end
    
    
    if key_pressed == "a" or key_pressed == "A" then
        current_key = "A"
    end
    if key_pressed == "j" or key_pressed == "J" then
        current_key = "J"
    end
    if key_pressed == "q" or key_pressed == "Q" then
        current_key = "Q"
    end
    if key_pressed == "k" or key_pressed == "K" then
        current_key = "K"
    end
    if key >= 50 and key <= 57 then
        current_key = key_pressed
    end
    
    
    print(path .. current_key .. deli .. current_seed)
    image_file = path .. current_key .. deli .. current_seed .. type
    -- Termina tu código
    
    if image_file then
        setImage(carta_image, image_file)
    end
end



callbackConfiguration(onClickLeft, onClickRight, onMouseMove, onKeyPress)
mainLoop()

