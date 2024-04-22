-- Constants
local DASH_EFFECT_DURATION = 300

function init()
    -- Bind castDashSpell to Ctrl + D
    g_keyboard.bindKeyDown("Ctrl+D", castDashSpell)
end

function terminate()
    -- Unbind the key
    g_keyboard.unbindKeyDown("Ctrl+D")
end

function castDashSpell()
    -- Make the player say the spell words to cast dash
    g_game.talk("dash");
    -- Set to dash shader
    modules.game_shaders.setMapShader('Dash')
    -- Set back to the default map shader after the predefined duration
    scheduleEvent(setDefaultMapShader, DASH_EFFECT_DURATION)
end

function setDefaultMapShader()
    modules.game_shaders.setMapShader('Default')
end
