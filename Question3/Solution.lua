-- Rename the method to a more meaningful name
-- Rename the parameter (membername) to follow the camel case rules
function removeMemberFromPlayerParty(playerId, memberName)
    -- Local variable should have local identifier
    local player = Player(playerId)

    -- Return if player is invalid to prevent invalid operations
    if not player then
        return
    end

    local party = player:getParty()

    -- Return if party is invalid to prevent invalid operations
    -- Depending on the situation, the following code may be redundant and can be removed
    if not party then
        return
    end

    for _, member in pairs(party:getMembers()) do
        -- party.getMembers returns a table of members which are, according to the context, Player objects
        -- It makes more sense to get the name from member and compare it with memberName, rather than getting the
        -- Player object using memberName and comparing it with member
        if member.getString("name") == memberName then
            party:removeMember(member)

            -- We can terminate the function here if no two players share the same name
            -- Remove the following line if it is not the case
            return
        end
    end
end
