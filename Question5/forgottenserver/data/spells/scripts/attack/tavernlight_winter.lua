-- This contains the logic of the spell that replicates the effect shown in Question 5. The spell is basically a three
-- cycles of four attacks, each of which has different area of effect. So I made SPELL_AREAS an array of four matrices
-- (one matrix for each attack). Also, each cycle lasts one second. So the delay between each attack should be 250 ms.

-- Contants
-- Even though the effect won't be rendered on some tiles, I made it cover a whole diamond so that the spell is also
-- useful in practice
local SPELL_AREAS = {
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 0},
        {1, 0, 0, 2, 0, 0, 1},
        {0, 1, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0}
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 1, 3, 1, 1, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
    {
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    }
}
local ANIMATION_DELAY = 250

-- Each combat is an attack
local combats = {}

for i = 1, #SPELL_AREAS * 3 do
    -- Since the effect was taken from the spell Eternal Winter, I simply used that spell's parameters for this custom
    -- spell
    combats[i] = Combat()
    combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    local areaIndex = i % #SPELL_AREAS

    -- Since the index of array starts at 1 in Lua, we need to turn 0 to the modulus, which is the size of SPELL_AREAS
    if areaIndex == 0 then
        areaIndex = #SPELL_AREAS
    end

    combats[i]:setArea(createCombatArea(SPELL_AREAS[areaIndex]))

    -- This damage formula was also taken from Eternal Winter
    function onGetFormulaValues(player, level, magicLevel)
        local min = (level / 5) + (magicLevel * 5.5) + 25
        local max = (level / 5) + (magicLevel * 11) + 50
        return -min, -max
    end

    combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
end

-- This function is used to execute an attack at the specified index
-- It takes IDs as arguments since the execution is delayed
-- We can't ensure that the creature and the variant are still valid after the delay, so we should check their validity
-- when an attack is actually going to be executed
local function executeCombat(index, creatureId, variantNumber)
    local creature = Creature(creatureId)

    -- Check if creature is valid
    if not creature then
        return
    end

    local variant = Variant(variantNumber)

    -- Check if variant is valid, although it is not used throughout this function
    if not variant then
        return
    end

    combats[index]:execute(creature, variant)
end

function onCastSpell(creature, variant)
    -- Since the first attack is executed instantly, we won't use addEvent
	combats[1]:execute(creature, variant)

    for i = 2, #combats do
        -- Delay the subsequent attacks accroding to their order
        addEvent(executeCombat, ANIMATION_DELAY * (i - 1), i, creature:getId(), variant:getNumber())
    end

    return true
end
