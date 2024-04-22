-- Constants
-- This shows how many tiles the player moves in each step during dashing
local DASH_PATTERN = { 3, 1, 1, 1 }
-- This is the delay between each step
local DASH_DELAY = 60

-- Move the creature by the specified distance
-- The creature will stop if there's something blocking the creature's way
-- This function takes creature's ID as an argument since this function will be delayed
-- We need to check the creature's validity each time this function is called
local function moveCreature(creatureId, distance)
    local creature = Creature(creatureId)

    -- Return if creature is invalid
    if not creature then
        return
    end

    local position = creature:getPosition();
    -- This is the last position that the creature can move to
    local prevPosition = Position(position);

    for _ = 1, distance do
        -- Get the next position using the creature's direction
        position:getNextPosition(creature:getDirection())
        local tile = Tile(position)

        -- If the next tile is not walkable, move the creature to the last walkable position
        if not tile or not tile:isWalkable() then
            creature:teleportTo(prevPosition)
            return
        end

        prevPosition = Position(position)
    end

    -- If nothing blocks the creature's way, move the creature to the destination
    creature:teleportTo(position)
end

function onCastSpell(creature, variant)
    -- The first step is instant, so we won't use addEvent
    moveCreature(creature:getId(), DASH_PATTERN[1])

    for i = 2, #DASH_PATTERN do
        -- Perform the subsequent steps
        addEvent(moveCreature, DASH_DELAY * (i - 1), creature:getId(), DASH_PATTERN[i])
    end

    -- Return false here since I don't want the word "dash" to appear in the game
	return false
end
