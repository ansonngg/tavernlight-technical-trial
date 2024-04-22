void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);

    // It is to determine whether the pointer, player, is constructed in this function
    // The data player, obtained from g_game.getPlayerByName, points to is probably stored somewhere else because of the
    // "get" keyword in the function's name
    // So the lifetime of the data player points to should be managed by another owner
    // The data should be deleted only if it is constructed in this function
    bool isPlayerTemporary = false;

    if (!player)
    {
        player = new Player(nullptr);

        if (!IOLoginData::loadPlayerByName(player, recipient))
        {
            // Release the memory before returning
            delete player;
            return;
        }

        isPlayerTemporary = true;
    }

    Item* item = Item::CreateItem(itemId);

    if (!item)
    {
        // !item being true means that item is a nullptr, which means that it doesn't need to be deleted
        // But player that is constructed in this function still needs to be deleted before returning
        if (isPlayerTemporary)
        {
            delete player;
        }

        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline())
    {
        IOLoginData::savePlayer(player);
    }

    // If player is constructed in this function, delete it before the function ends
    if (isPlayerTemporary)
    {
        delete player;
    }

    // If the function reaches here, item is not a nullptr
    // But g_game.internalAddItem probably stores its data in somewhere else
    // My guess is that item should not be deleted
    // But if it is not the case, uncomment the following line
    // delete item;
}
