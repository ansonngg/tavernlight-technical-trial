-- Introduce contants to avoid magic numbers
local STORAGE_INDEX = 1000
local RELEASE_STORAGE_DELAY = 1000

local function releaseStorage(playerId)
    local player = Player(playerId)

    -- If player is invalid, return directly
    if not player then
        return
    end

    player:setStorageValue(STORAGE_INDEX, -1)
end

function onLogout(player)
    -- Check if player is valid to prevent invalid operations
    -- If player is invalid, return false to indicate that the logout operation fails
    if not player then
        print("Player is invalid.")
        return false;
    end

    if player:getStorageValue(STORAGE_INDEX) == 1 then
        -- Since the release operation is delayed, it's possible that player becomes invalid when the operation is being
        -- executed
        -- It's safer to pass the player's ID into the method so that it can try to get the player using the ID later
        -- and check for validity
        addEvent(releaseStorage, RELEASE_STORAGE_DELAY, player:getId())
    end

    return true
end
