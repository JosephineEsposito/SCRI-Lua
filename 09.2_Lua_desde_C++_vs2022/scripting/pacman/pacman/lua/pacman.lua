-- VARIABLES --
-- game size
width = 300
height = 300

-- points
coin_score = 50

-- powerups
powerup_score = 5000
powerup_duration = 5
powerup_speed_multiplier = 2.0

-- colors
powerup_pacman_color_r = 255
powerup_pacman_color_g = 255
powerup_pacman_color_b = 255

-- number of points for medal
bronze_medal_points = 100

-- END OF VARIABLES --



function getWidth()
	return width
end


-- get pacman color after powerup
function getPacmanPowerUpColor(lives)
	if lives == 1.5 then
		return {r = powerup_pacman_color_r, g = 0, b = 0}
	elseif lives == 1.0 then
		return {r = powerup_pacman_color_r, g = 165, b = 0}
    elseif lives == 0.5 then
        return {r = 0, g = powerup_pacman_color_g, b = 0}
    elseif lives == 0.0 then
        return {r = 0, g = 0, b = powerup_pacman_color_b}
    else
        return {r = 255, g = 255, b = 255}
	end
end
	