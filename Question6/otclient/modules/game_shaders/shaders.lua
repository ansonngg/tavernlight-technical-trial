-- Constants
-- I have modified a few things about this variable
--     1. Removed all the unused shaders and added my own
--     2. Instaed of making the shader's name one of the fields of an object, I made it a key of this table so that
--        we can search the details of a shader using its name quickly
--     3. Renamed frag to fragmentShaderPath
local MAP_SHADERS = {
    ['Dash'] = {
        fragmentShaderPath = 'shaders/fragment/dash.frag',
        usePlayerOutfitTexture = true
    }
}

-- Configure the shader using the details provided
local function configureShader(shader, details)
    local player = g_game.getLocalPlayer()

    -- If the local player is valid and usePlayerOutfitTexture is set, update the player's outfit texture for it
    if player and details.usePlayerOutfitTexture then
        shader:updateCreatureOutfitMultiTexture(player:getId())
    end
end

-- Set a map shader specified by name
-- This function is exposed to other modules
function setMapShader(shaderName)
    local map = modules.game_interface.getMapPanel()

    -- Set the map shader to nil (which is default) when the caller of this function wants to set the map shader to
    -- 'Default'
    if shaderName == 'Default' then
        map:setMapShader(nil)
        return
    end

    local shader = g_shaders.getShader(shaderName)

    -- Return if the shader is invalid
    if not shader then
        return
    end

    local details = MAP_SHADERS[shaderName]

    -- If details is valid, configure the shader using details
    if details then
        configureShader(shader, details)
    end

    -- Set the required map shader
    map:setMapShader(shader)
end

function init()
    -- In mehah/otclient's version, the module supports three types of shaders
    -- Here we only support map shaders, so we only need one type of register function to handle all the shaders
	local function registerMapShader(name, details)
        local path = resolvepath(details.fragmentShaderPath)

        if path then
            g_shaders.createMapShader(name, details.fragmentShaderPath)

            -- Originally, the module will set tex1 and tex2 of the shader here
            -- But we don't need them, so I removed them
        end
    end

    -- I renamed opts to details
	for name, details in pairs(MAP_SHADERS) do
        registerMapShader(name, details)
    end
end

-- This function only acts as a placeholder
-- We don't have anything to do when terminating at the moment
function terminate()
end
