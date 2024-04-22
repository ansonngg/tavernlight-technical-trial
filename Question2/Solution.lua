function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"

    -- Variable with name result is used below but the original name of this variable was resultId
    -- Sync up the variable names to prevent errors
    local result = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- Return if result is invalid to prevent invalid operations
    if not result then
        return
    end

    -- result should be an iterator that iterates over every row that satisfies the query
    -- So we should loop through result in order to print all valid guilds' names
    for row in result do
        local guildName = row.getString("name")
        print(guildName)
    end
end
