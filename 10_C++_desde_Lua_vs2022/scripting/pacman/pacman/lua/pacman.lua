
coin_score = 50
powerup_score = 5000
powerup_duration = 5
powerup_speed_multiplier = 2.0
bronze_medal_points = 100

myPacman = Pacman()

function myPacman:getPowerUpColor(lives_param)
    if lives_param == 1.5 then
        return {r = 255, g = 0, b = 0}
    elseif lives_param == 1.0 then
        return {r = 255, g = 165, b = 0}
    elseif lives_param == 0.5 then
        return {r = 0, g = 255, b = 0}
    elseif lives_param == 0.0 then
        return {r = 0, g = 0, b = 255}
    else
        return {r = 255, g = 255, b = 255}
    end
end

function myPacman:onPowerUpEaten(current_score)
    local current_lives = self:getLivesValue()

    self:setSpeedMultiplier(powerup_speed_multiplier)
    
    self:setPowerUpDuration(powerup_duration)

    local color = self:getPowerUpColor(current_lives)
    self:setColor(color.r, color.g, color.b)

    local new_score = current_score + powerup_score
    return new_score
end

function myPacman:onPowerUpGone()
    self:setColor(255, 0, 0)
    self:setSpeedMultiplier(1.0)
end

function getWidth()
    return 200
end