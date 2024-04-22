-- Constants
-- 60 FPS
local UPDATE_TIMESTEP = 1000 / 60
-- The number of pixels the jump button move in each frame
local BUTTON_SPEED = 2

-- UI widgets
local jumpWindow
local windowContent
local jumpButton

-- The window toggle button on the top menu
local jumpWindowButton

-- This means if the jump button should jump to the right in the next frame
local shouldJump = true
-- This is the distance between the left margin of the window content and the jump button
local buttonOffsetX
-- This is the distance between the top margin of the window content and the jump button
local buttonOffsetY
-- This saves the update event that is used when we want to remove the event
-- The update event will handle all the position changes to make all the transitions consistent
-- So no position changes should occur outside the update function
local updateEvent

function init()
    jumpWindow = g_ui.displayUI('jump')
    -- Hide the window first when this module is loaded
    jumpWindow:hide()
    -- Add the window toggle button on the top menu
    jumpWindowButton = modules.client_topmenu.addLeftButton('jumpWindowButton', tr('Jump'), '/images/topbuttons/particles', toggle)
    -- Get the UI widgets
    windowContent = jumpWindow:recursiveGetChildById('windowContent')
    jumpButton = windowContent:recursiveGetChildById('jumpButton')
end

function terminate()
    jumpWindow:destroy()
    jumpWindowButton:destroy()
end

function hide()
    jumpWindow:hide()
    -- Remove the update event
    removeEvent(updateEvent)
end

function show()
    jumpWindow:show()
    jumpWindow:raise()
    jumpWindow:focus()
    -- The jump button should be placed on the right of the window content whenever the window is opened
    shouldJump = true
    -- Start the update event
    updateEvent = cycleEvent(update, UPDATE_TIMESTEP)
end

function toggle()
    if jumpWindow:isVisible() then
        hide()
    else
        show()
    end
end

function onJumpClick()
    -- This will make the jump button jump in the next frame
    shouldJump = true
end

local function jump()
    local position = windowContent:getPosition()
    -- We shouldn't make the jump button outside the window content, so we need to subtract its width
    buttonOffsetX = windowContent:getWidth() - jumpButton:getWidth()
    position.x = position.x + buttonOffsetX
    -- Randomly pick a y position while the jump button should sit inside the window content completely
    buttonOffsetY = math.random(0, windowContent:getHeight() - jumpButton:getHeight())
    position.y = position.y + buttonOffsetY
    -- Set the jump button's position
    jumpButton:setPosition(position)
end

function update()
    -- Jump if shouldJump is set
    -- No need to move the jump button after jumping
    if shouldJump then
        jump()
        shouldJump = false
        return
    end

    -- Move the jump button to the left, so we substract the speed
    buttonOffsetX = buttonOffsetX - BUTTON_SPEED

    -- If the jump button moves over the left margin of the window content, jump and return
    if buttonOffsetX < 0 then
        jump()
        return
    end

    -- Always take the position of the window content as a reference and displace the jump button using offsets
    -- That way, we can ensure that the jump button will follow the window when the window is moved
    local position = windowContent:getPosition()
    position.x = position.x + buttonOffsetX
    position.y = position.y + buttonOffsetY
    jumpButton:setPosition(position)
end
