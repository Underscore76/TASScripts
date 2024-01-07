local movement = require('movement')
local pathing = {
    safetySeedCount=999*2
}

local chests = {
    SeedChest={loc="Farm", chestTile=Vector2(36,12), walkTile=Vector2(37,13)},
    SafetySeedChest={loc="Farm", chestTile=Vector2(40,16), walkTile=Vector2(40,17)},
    ForageChest={loc="Farm", chestTile=Vector2(36,11), walkTile=Vector2(37,12)},
    FiberChest={loc="Farm", chestTile=Vector2(35,11), walkTile=Vector2(35,10)},
    WoodChest={loc="Farm", chestTile=Vector2(34,11), walkTile=Vector2(33,10)},
    Workbench={loc="Farm", benchTile=Vector2(35,12), walkTile=Vector2(36,13)},
    HardwoodChest={loc="Cellar", chestTile=Vector2(3,5), walkTile=Vector2(4,5)},
    FenceChest={loc="FarmHouse", chestTile=Vector2(32,22), walkTile=Vector2(31,21)},
    StoneChests={
        loc="Desert", 
        chests={
            {loc="Desert", chestTile=Vector2(40,25), walkTile=Vector2(41,25)},
            {loc="Desert", chestTile=Vector2(42,25), walkTile=Vector2(41,25)},
            {loc="Desert", chestTile=Vector2(40,26), walkTile=Vector2(41,25)},
            {loc="Desert", chestTile=Vector2(42,26), walkTile=Vector2(41,25)},
        }
    },
    SaplingChests={
        loc="Farm",
        chests={
            -- bottom row, right to left
            {loc="Farm", chestTile=Vector2(32,13), walkTile=Vector2(33,12)},
            {loc="Farm", chestTile=Vector2(32,11), walkTile=Vector2(33,12)},
            {loc="Farm", chestTile=Vector2(31,13), walkTile=Vector2(32,12)},
            {loc="Farm", chestTile=Vector2(31,11), walkTile=Vector2(32,12)},
            {loc="Farm", chestTile=Vector2(30,13), walkTile=Vector2(31,12)},
            {loc="Farm", chestTile=Vector2(30,11), walkTile=Vector2(31,12)},
            {loc="Farm", chestTile=Vector2(29,13), walkTile=Vector2(30,12)},
            {loc="Farm", chestTile=Vector2(28,13), walkTile=Vector2(29,12)},
            {loc="Farm", chestTile=Vector2(28,11), walkTile=Vector2(29,12)},
            {loc="Farm", chestTile=Vector2(27,13), walkTile=Vector2(28,12)},
            {loc="Farm", chestTile=Vector2(27,11), walkTile=Vector2(28,12)},
            {loc="Farm", chestTile=Vector2(26,13), walkTile=Vector2(27,12)},
            {loc="Farm", chestTile=Vector2(26,11), walkTile=Vector2(27,12)},
            {loc="Farm", chestTile=Vector2(25,13), walkTile=Vector2(26,12)},
            {loc="Farm", chestTile=Vector2(25,11), walkTile=Vector2(26,12)},
            {loc="Farm", chestTile=Vector2(24,13), walkTile=Vector2(25,12)},
            {loc="Farm", chestTile=Vector2(24,11), walkTile=Vector2(25,12)},
            {loc="Farm", chestTile=Vector2(23,13), walkTile=Vector2(24,12)},
            {loc="Farm", chestTile=Vector2(23,11), walkTile=Vector2(24,12)},
            {loc="Farm", chestTile=Vector2(22,13), walkTile=Vector2(23,12)},
            {loc="Farm", chestTile=Vector2(22,11), walkTile=Vector2(23,12)},
            -- left vertical wall
            {loc="Farm", chestTile=Vector2(20,13), walkTile=Vector2(21,12)},
            {loc="Farm", chestTile=Vector2(20,12), walkTile=Vector2(21,12)},
            {loc="Farm", chestTile=Vector2(20,11), walkTile=Vector2(21,12)},
            {loc="Farm", chestTile=Vector2(20,10), walkTile=Vector2(21,11)},
            {loc="Farm", chestTile=Vector2(20,9), walkTile=Vector2(21,10)},
            -- middle row left to right
            {loc="Farm", chestTile=Vector2(22,10), walkTile=Vector2(23,9)},
            {loc="Farm", chestTile=Vector2(23,10), walkTile=Vector2(23,9)},
            {loc="Farm", chestTile=Vector2(23,8), walkTile=Vector2(23,9)},
            {loc="Farm", chestTile=Vector2(24,10), walkTile=Vector2(24,9)},
            {loc="Farm", chestTile=Vector2(24,8), walkTile=Vector2(24,9)},
            {loc="Farm", chestTile=Vector2(25,10), walkTile=Vector2(25,9)},
            {loc="Farm", chestTile=Vector2(25,8), walkTile=Vector2(25,9)},
            {loc="Farm", chestTile=Vector2(26,10), walkTile=Vector2(26,9)},
            {loc="Farm", chestTile=Vector2(26,8), walkTile=Vector2(26,9)},
            {loc="Farm", chestTile=Vector2(27,10), walkTile=Vector2(27,9)},
            {loc="Farm", chestTile=Vector2(27,8), walkTile=Vector2(27,9)},
            {loc="Farm", chestTile=Vector2(28,10), walkTile=Vector2(28,9)},
            {loc="Farm", chestTile=Vector2(28,8), walkTile=Vector2(28,9)},
            {loc="Farm", chestTile=Vector2(30,10), walkTile=Vector2(30,9)},
            {loc="Farm", chestTile=Vector2(30,8), walkTile=Vector2(30,9)},
            {loc="Farm", chestTile=Vector2(31,10), walkTile=Vector2(31,9)},
            {loc="Farm", chestTile=Vector2(32,10), walkTile=Vector2(32,9)},
            -- top row right to left
            {loc="Farm", chestTile=Vector2(28,7), walkTile=Vector2(29,6)},
            {loc="Farm", chestTile=Vector2(28,5), walkTile=Vector2(29,6)},
            {loc="Farm", chestTile=Vector2(27,7), walkTile=Vector2(28,6)},
            {loc="Farm", chestTile=Vector2(27,5), walkTile=Vector2(28,6)},
            {loc="Farm", chestTile=Vector2(26,7), walkTile=Vector2(27,6)},
            {loc="Farm", chestTile=Vector2(26,5), walkTile=Vector2(27,6)},
            {loc="Farm", chestTile=Vector2(25,7), walkTile=Vector2(26,6)},
            {loc="Farm", chestTile=Vector2(25,5), walkTile=Vector2(26,6)},
            {loc="Farm", chestTile=Vector2(24,7), walkTile=Vector2(25,6)},
            {loc="Farm", chestTile=Vector2(24,5), walkTile=Vector2(25,6)},
            {loc="Farm", chestTile=Vector2(23,7), walkTile=Vector2(24,6)},
            {loc="Farm", chestTile=Vector2(23,5), walkTile=Vector2(24,6)},
            {loc="Farm", chestTile=Vector2(22,5), walkTile=Vector2(23,6)},
        }
    }
}

pathing.chests = chests

function pathing.EscapeMenu()
    if Game1.activeClickableMenu ~= nil then
        movement.AdvanceUntilExitMenu(Keys.Escape, {left=true}, true)
    end
end

function pathing.GoToFarmHouse()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "FarmHouse" then
        return
    elseif Game1.currentLocation.Name == "Cellar" then
        movement.WalkToTile(Vector2(4,2))
        movement.AdvanceUntilLocationChange({Keys.W})
    elseif Game1.currentLocation.Name == "Farm" then
        local frame_func = pathing.mouseTile(Vector2(64,14))
        movement.WalkToTile(Vector2(64,15), frame_func)
        local res = frame_func()
        res.mouse.right = true
        movement.AdvanceUntilLocationChange(nil, res.mouse, true)
    else
        pathing.GoToFarm()
        pathing.GoToFarmHouse()
    end
end

function pathing.GoToCellar()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Cellar" then
        return
    elseif Game1.currentLocation.Name == "FarmHouse" then
        movement.WalkToTile(Vector2(5,24))
        movement.AdvanceUntilLocationChange({Keys.S})
    else
        pathing.GoToFarmHouse()
        pathing.GoToCellar()
    end
end

function pathing.GoToFarm()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Farm" then
        return
    elseif Game1.currentLocation.Name == "Cellar" then
        pathing.GoToFarmHouse()
        pathing.GoToFarm()
    elseif Game1.currentLocation.Name == "FarmHouse" then
        movement.WalkToTile(Vector2(12,20))
        movement.AdvanceUntilLocationChange({Keys.S})
    elseif Game1.currentLocation.Name == "Greenhouse" then
        movement.WalkToTile(Vector2(10,23))
        movement.AdvanceUntilLocationChange({Keys.S})
    else
        movement.SwapToItem("Return Scepter")
        local p = Game1.player:getTileLocation()
        local mouse = movement.GetMouseTileFromGlobal(p.X,p.Y)
        movement.AdvanceUntilLocationChange({Keys.C}, mouse, true)
    end
end

function pathing.GoToBusStop()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "BusStop" then
        return
    elseif Game1.currentLocation.Name == "Town" then
        local p = Game1.player:getTileLocation()
        local y = math.max(math.min(55,p.Y),53)
        movement.WalkToTile(Vector2(0,y))
        movement.AdvanceUntilLocationChange({Keys.A})
    else
        pathing.GoToFarm()
        local p = Game1.player:getTileLocation()
        p.X = 79
        p.Y = math.max(math.min(18,p.Y),15)
        movement.WalkToTile(p)
        movement.AdvanceUntilLocationChange({Keys.D})
    end
end

function pathing.GoToTown()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Town" then
        return
    elseif Game1.currentLocation.Name == "BusStop" then
        local p = Game1.player:getTileLocation()
        p.X = 34
        p.Y = math.max(math.min(25,p.Y),22)
        movement.WalkToTile(p)
        movement.AdvanceUntilLocationChange({Keys.D})
    else 
        pathing.GoToBusStop()
        pathing.GoToTown()
    end
end

function pathing.GoToSeedShop()
    -- 42,57 to 45,57, mouse 43,56 to 44,56
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "SeedShop" then
        return
    elseif Game1.currentLocation.Name == "Town" then
        if Game1.player:getTileLocation().X < 43 then
            local frame_func = pathing.mouseTile(Vector2(43,56))
            movement.WalkToTile(Vector2(43,57), frame_func)
            local res = frame_func()
            res.mouse.right = true
            movement.AdvanceUntilLocationChange(nil, res.mouse, true)
        else
            local frame_func = pathing.mouseTile(Vector2(44,56))
            movement.WalkToTile(Vector2(44,57), frame_func)
            local res = frame_func()
            res.mouse.right = true
            movement.AdvanceUntilLocationChange(nil, res.mouse, true)
        end
    else
        pathing.GoToTown()
        pathing.GoToSeedShop()
    end
end

function pathing.OpenSeedShopStore()
    pathing.GoToSeedShop()
    local frame_func = pathing.mouseTile(Vector2(5,18))
    movement.WalkToTile(Vector2(6,19), frame_func)
    local res = frame_func()
    res.mouse.right = true
    movement.AdvanceUntilMenu(nil, res.mouse, true)
end

function pathing.SellSaplings()
    -- if pathing.CountInventory("Tea Sapling") == 0 then
    --     return
    -- end
    pathing.OpenSeedShopStore()
    
    while pathing.CountInventory("Tea Sapling") > 0 do
        local mouse,_ = movement.GetChestInventoryMouse("Tea Sapling")
        if mouse == nil then
            break
        end
        advance({mouse={X=mouse.X, Y=mouse.Y, left=true}})
        advance({mouse=mouse})
    end
    movement.AdvanceUntilExitMenu(Keys.Escape, {left=true}, true)
end

function pathing.GoToGreenhouse()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Greenhouse" then
        return
    elseif Game1.currentLocation.Name == "Farm" then
        local frame_func = pathing.mouseTile(Vector2(55,16))
        movement.WalkToTile(Vector2(55,17), frame_func)
        local res = frame_func()
        res.mouse.right = true
        movement.AdvanceUntilLocationChange(nil, res.mouse, true)
    else
        pathing.GoToFarm()
        pathing.GoToGreenhouse()
    end
end


function pathing.GoToOasis()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "SandyHouse" then
        return
    elseif Game1.currentLocation.Name == "Club" then
        movement.WalkToTile(Vector2(8,13))
        movement.AdvanceUntilLocationChange({Keys.S})
    else
        pathing.GoToDesert()
        local frame_func = pathing.mouseTile(Vector2(6,51)) 
        movement.WalkToTile(Vector2(7,52), frame_func)
        local res = frame_func()
        while Game1.timeOfDay < 900 do
            advance({mouse=res.mouse})
        end
        res.mouse.right = true
        movement.AdvanceUntilLocationChange(nil, res.mouse, true)
    end
end

function pathing.OpenOasisStore()
    if Game1.activeClickableMenu ~= nil then
        if Game1.activeClickableMenu:GetType().Name == "ShopMenu" and
            Game1.activeClickableMenu.storeContext == "SandyHouse" then
            return
        end
        pathing.EscapeMenu()
    end
    pathing.GoToOasis()
    local frame_func = pathing.mouseTile(Vector2(2,7)) 
    movement.WalkToTile(Vector2(3,7), frame_func)
    local res = frame_func()
    res.mouse.right = true
    movement.AdvanceUntilMenu(nil, res.mouse, true)
end

function pathing.GoToDesert()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Desert" then
        return
    elseif Game1.currentLocation.Name == "SandyHouse" then
        movement.WalkToTile(Vector2(4,9))
        movement.AdvanceUntilLocationChange({Keys.S})
    elseif Game1.currentLocation.Name == "Club" then
        pathing.GoToOasis()
        pathing.GoToDesert()
    else
        pathing.GoToFarm()
        local frame_func = pathing.mouseTile(Vector2(49,12)) 
        movement.WalkToTile(Vector2(48,12), frame_func)
        local res = frame_func()
        res.mouse.right = true
        movement.AdvanceUntilLocationChange(nil, res.mouse, true)
    end
end

function pathing.OpenDesertTrader()
    if Game1.activeClickableMenu ~= nil then
        if Game1.activeClickableMenu:GetType().Name == "ShopMenu" and
            Game1.activeClickableMenu.storeContext == "Desert" then
            return
        end
        pathing.EscapeMenu()
    end
    pathing.GoToDesert()
    local frame_func = pathing.mouseTile(Vector2(41,24)) 
    movement.WalkToTile(Vector2(41,25), frame_func)
    local res = frame_func()
    advance({mouse=res.mouse})
    res.mouse.right = true
    movement.AdvanceUntilMenu(nil, res.mouse, true)
end

function pathing.GoToCasino()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "Club" then
        return
    else
        pathing.GoToOasis()
        movement.WalkToTile(Vector2(17,2))
        movement.AdvanceUntilLocationChange({Keys.W})
    end
end

function pathing.OpenCasinoStore()
    if Game1.activeClickableMenu ~= nil then
        if Game1.activeClickableMenu:GetType().Name == "ShopMenu" and
            Game1.activeClickableMenu.storeContext == "Club" then
            return
        end
        pathing.EscapeMenu()
    end
    pathing.GoToCasino()
    local frame_func = pathing.mouseTile(Vector2(25,3)) 
    movement.WalkToTile(Vector2(24,4), frame_func)
    local res = frame_func()
    res.mouse.right = true
    movement.AdvanceUntilMenu(nil, res.mouse, true)
end

function pathing.OpenHighRollerCalicoJack()
    pathing.EscapeMenu()
    pathing.GoToCasino()
    local frame_func = pathing.mouseTile(Vector2(23,10)) 
    movement.WalkToTile(Vector2(22,9), frame_func)
    local res = frame_func()
    res.mouse.right = true
    movement.AdvanceUntilMenu(nil, res.mouse, true)
end

function pathing.OpenCalicoSpin()
    if (Game1.currentMinigame ~= nil and Game1.currentMinigame:GetType().Name == "Slots") then
        return
    end
    pathing.EscapeMenu()
    pathing.GoToCasino()
    local frame_func = pathing.mouseTile(Vector2(11,8))
    movement.WalkToTile(Vector2(11,9), frame_func)
    local res = frame_func()
    res.mouse.right = true
    movement.AdvanceUntilMinigame(nil, res.mouse, true)
end

function pathing.CloseCalicoSpin()
    while Game1.currentMinigame ~= nil do
        advance({keyboard={Keys.Escape}})
    end
end

function pathing.GoToIslandSouth()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "IslandSouth" then
    elseif string.find(Game1.currentLocation.Name,"Island") ~= nil then
        if Game1.currentLocation.Name == "IslandWest" then
            movement.WalkToTile(Vector2(105,41))
            movement.AdvanceUntilLocationChange({Keys.D})
        else
            pathing.GoToFarm()
            pathing.GoToIslandSouth()
        end
    else
        pathing.GoToFarm()
        local p = Game1.player:getTileLocation()
        local walkTile = nil
        local frame_func = nil
        if p.X <= 48 then
            walkTile = Vector2(48,16)
            frame_func = pathing.mouseTile(Vector2(49,16))
        else
            walkTile = Vector2(50,17)
            frame_func = pathing.mouseTile(Vector2(50,16))
        end
        movement.WalkToTile(walkTile, frame_func)
        local res = frame_func()
        res.mouse.right = true
        movement.AdvanceUntilLocationChange(nil, res.mouse, true)
    end
end

function pathing.GoToIslandWest()
    pathing.EscapeMenu()
    if Game1.currentLocation.Name == "IslandWest" then
        return
    else
        pathing.GoToIslandSouth()
        movement.WalkToTile(Vector2(0,11))
        movement.AdvanceUntilLocationChange({Keys.A})
    end

end

function pathing.mouseTile(tile)
    return function ()
        return {
            override_keyboard=false,
            mouse=movement.GetMouseTileFromGlobal(tile.X,tile.Y)
    }
    end
end

function pathing.CountChest(locationName, chestTile, itemName)
    -- local d = interface:CountChest(locationName, chestTile)
    -- if d:ContainsKey(itemName) then
    --     return d[itemName]
    -- end
    -- return 0
    local loc = Game1.getLocationFromName(locationName)
    local chest = loc.Objects[Vector2(chestTile.X, chestTile.Y)]
    local count = 0
    for _,v in list_items(chest.items) do
        if v ~= nil and v.Name == itemName then
            count = count + v.Stack
        end
    end
    return count
end

function pathing.CountInventory(itemName)
    -- local d = interface:CountInventory()
    -- if d:ContainsKey(itemName) then
    --     return d[itemName]
    -- end
    -- return 0
    local count = 0
    for _,v in list_items(Game1.player.items) do
        if v ~= nil and v.Name == itemName then
            count = count + v.Stack
        end
    end
    return count
end

function pathing.CountMachines(locName, objName)
    local state = interface:GetMachineState(locName, objName)
    return state.NumMachine
    -- local loc = Game1.getLocationFromName(locName)
    -- local count = 0
    -- for k,v in dict_items(loc.Objects) do
    --     if v.Name == objName then
    --         count = count + 1
    --     end
    -- end
    -- return count
end


function pathing.CountMachinesDone(locName, objName)
    local state = interface:GetMachineState(locName, objName)
    return state.NumMachineDone
end

function pathing.CountMachineDoneItems(locName, objName, heldObject)
    local state = interface:GetMachineState(locName, objName)
    if state.ItemCounts:ContainsKey(heldObject) then
        return state.ItemCounts[heldObject]
    end
    return 0
end

function pathing.BuyItem(itemName, toBuy, maxItems)
    local function heldStack()
        if Game1.activeClickableMenu.heldItem == nil then
            return 0
        end
        return Game1.activeClickableMenu.heldItem.Stack
    end
    local count = 0
    if maxItems ~= nil then 
        count = pathing.CountInventory(itemName)
        toBuy = math.max(0, maxItems - count)
    end
    if toBuy <= 0 then
        return
    end
    -- need to figure out how to move the menus...
    local index = -1
    for i, v in list_items(Game1.activeClickableMenu.forSale) do
        if v.Name == itemName then
            index = i
            break
        end
    end
    if index == -1 then
        error(string.format("Could not find item %s in shop", itemName))
    end
    -- get position x,y
    local menu = Game1.activeClickableMenu
    local scrollBarRunner = Reflector.GetDynamicCastField(menu,"scrollBarRunner")
    local x = menu.scrollBar.bounds.Center.X
    local y
    if index > 4 then
        y = scrollBarRunner.Y + scrollBarRunner.Height * (index / menu.forSale.Count)
    else 
        y = scrollBarRunner.Y
    end
    advance({mouse={X=x, Y=y}})
    advance({mouse={X=x, Y=y, left=true}})
    index = index - menu.currentItemIndex
    local keyboard = {}
    local mouse = {
        X=menu.forSaleButtons[index].bounds.Center.X, 
        Y=menu.forSaleButtons[index].bounds.Center.Y
    }
    local clickMouse = {
        X=mouse.X, 
        Y=mouse.Y, 
        left=true
    }
    while toBuy - count > 0  do
        local n = heldStack()
        if toBuy-count - n >= 25 then
            keyboard = {Keys.LeftShift, Keys.LeftControl}
        elseif toBuy-count - n >= 5 then
            keyboard = {Keys.LeftShift}
        else
            keyboard = {}
        end
        if n < math.min(999, toBuy-count) then
            advance({mouse=mouse, keyboard=keyboard})
            advance({mouse=clickMouse, keyboard=keyboard})
        end
        n = heldStack()
        if n >= math.min(999, toBuy-count) then
            local invMouse,_ = movement.GetChestInventoryMouse(itemName, 999-n)
            if invMouse == nil then
                invMouse = movement.GetEmptyCraftingSlotMouse(Game1.activeClickableMenu)
            end
            if invMouse ~= nil then
                advance({mouse={X=invMouse.X, Y=invMouse.Y}, keyboard=keyboard})
                advance({mouse={X=invMouse.X, Y=invMouse.Y, left=true}, keyboard=keyboard})
            else
                error(string.format("Could not find empty inventory slot for %s", itemName))
            end
            count = pathing.CountInventory(itemName)
        end
    end
    -- GetChestInventoryMouse
end

function pathing.GetFromChestInventory(name, total)
    if total == 0 then return end
    local count = 0
    -- get all full stacks
    while total-count >= 999 do
        local mouse, item = movement.GetChestMouse(name, 999)
        if item == nil or mouse == nil then
            break
        end
        advance({mouse=mouse})
        advance({mouse={X=mouse.X, Y=mouse.Y, left=false}})
        count = count + item.Stack
    end
    -- just dumb grab half/1 at a time
    while total - count > 0 do
        local mouse, item = movement.GetChestMouse(name)
        if item == nil or mouse == nil then
            return
        end
        mouse.left = false
        mouse.right = true
        local halfStack = (item.Stack+1) // 2
        if item.Stack <= total-count then
            advance({mouse=mouse})
            advance({mouse={X=mouse.X, Y=mouse.Y, left=false}})
            count = count + item.Stack
        elseif halfStack <= total - count then
            advance({keyboard={Keys.LeftShift}})
            advance({keyboard={Keys.LeftShift}, mouse=mouse})
            advance({mouse={X=mouse.X, Y=mouse.Y}})
            count = count + halfStack
        else
            advance({mouse=mouse})
            advance({mouse={X=mouse.X, Y=mouse.Y}})
            count = count + 1
        end
    end
    local pos = Game1.activeClickableMenu.organizeButton.bounds.Center
    local mouse = {X=pos.X, Y=pos.Y, left=true}
    advance({mouse=mouse})
end

function pathing.SellItem(name, total)
    local count = 0
    -- dump any stack below the needed amount
    while true do
        local mouse, item = movement.GetChestInventoryMouse(name, total-count)
        if item == nil or mouse == nil then
            break
        end
        advance({mouse=mouse})
        advance({mouse={X=mouse.X, Y=mouse.Y, left=false}})
        count = count + item.Stack
    end
    -- just dumb grab half/1 at a time
    while total - count > 0 do
        print(total-count)
        local mouse, item = movement.GetChestInventoryMouse(name)
        if item == nil or mouse == nil then
            return
        end
        mouse.left = false
        mouse.right = true
        local halfStack = (item.Stack+1) // 2
        if halfStack < total - count then
            advance({keyboard={Keys.LeftShift}})
            advance({keyboard={Keys.LeftShift}, mouse=mouse})
            advance({mouse={X=mouse.X, Y=mouse.Y}})
            count = count + halfStack
        else
            advance({mouse=mouse})
            advance({mouse={X=mouse.X, Y=mouse.Y}})
            count = count + 1
        end
    end
end

function pathing.Wait(time)
    while Game1.timeOfDay < time do
        advance()
    end
end

function pathing.HaveItems(item, minStackSize)
    local inv = movement.GetInventoryKey(item, minStackSize)
    return inv ~= nil
end

function pathing.CollectFromChest(walkTile, chestTile, item, minStackSize)
    local count = pathing.CountChest(Game1.currentLocation.Name, chestTile, item)
    if count < minStackSize then
        return false
    end
    local n = movement.WalkToTile(walkTile, pathing.mouseTile(chestTile))
    if n <= 1 then
        advance({mouse=movement.GetMouseTileFromGlobal(chestTile.X,chestTile.Y)})
    end
    movement.OpenChest(chestTile.X, chestTile.Y)
    local mouse,_ = movement.GetChestMouse(item, minStackSize)
    advance({mouse=mouse})
    advance({keyboard={Keys.E}})
    return true
end

function pathing.HandleRecoloring(chestTile, itemName)
    local picker = Game1.activeClickableMenu.discreteColorPickerCC
    local blank = {X=picker[20].bounds.Center.X, Y=picker[20].bounds.Center.Y}
    local green = {X=picker[5].bounds.Center.X, Y=picker[5].bounds.Center.Y}
    local yellow = {X=picker[7].bounds.Center.X, Y=picker[7].bounds.Center.Y}
    local count = pathing.CountChest(Game1.currentLocation.Name, chestTile, itemName)
    local mouse
    if count == 999*36 then
        mouse = green        
    elseif count == 0 then
        mouse = blank
    else
        mouse = yellow
    end
    advance({mouse=mouse})
    mouse.left = true
    advance({mouse=mouse})
end

function pathing.DumpToChest(walkTile, chestTile, itemName)
    movement.WalkToTile(walkTile, pathing.mouseTile(chestTile))
    advance({mouse=movement.GetMouseTileFromGlobal(chestTile.X,chestTile.Y)})
    movement.OpenChest(chestTile.X, chestTile.Y)
    if itemName ~= nil then
        local mouse,_ = movement.GetChestInventoryMouse(itemName)
        if mouse == nil then
            return
        end
        advance({mouse=mouse})
        advance({mouse={X=mouse.X, Y=mouse.Y,}})
    end
    local pos = Game1.activeClickableMenu.fillStacksButton.bounds.Center
    local mouse = {X=pos.X, Y=pos.Y, left=true}
    advance({mouse=mouse})
    if itemName ~= nil then
        pathing.HandleRecoloring(chestTile, itemName)
    end
    advance({keyboard={Keys.E}})
end

function pathing.DumpToChests(chests, itemName)
    for i, chest in ipairs(chests.chests) do
        local count = pathing.CountChest(chest.loc, chest.chestTile, itemName)
        local frame_func = pathing.mouseTile(chest.chestTile)
        if count < 999*36 and count > 0 then
            pathing.DumpToChest(chest.walkTile, chest.chestTile, itemName)
        elseif count == 0 then
            movement.WalkToTile(chest.walkTile, frame_func)
            advance({mouse=frame_func().mouse})
            movement.OpenChest(chest.chestTile.X, chest.chestTile.Y)
            while pathing.CountInventory(itemName) > 0 do
                local mouse,_ = movement.GetChestInventoryMouse(itemName)
                advance({mouse=mouse})
                advance()
            end
            pathing.HandleRecoloring(chest.chestTile, itemName)
            advance({keyboard={Keys.E}})
            advance()
        end
        if pathing.CountInventory(itemName) == 0 then
            break
        end
    end
end

function pathing.PullFromChest(walkTile, chestTile, itemName, minEmptySlots)
    local function count()
        return pathing.CountChest(Game1.currentLocation.Name, chestTile, itemName)
    end
    if minEmptySlots == nil then
        minEmptySlots = 1
    end
    movement.WalkToTile(walkTile, pathing.mouseTile(chestTile))
    movement.OpenChest(chestTile.X, chestTile.Y)
    while movement.GetEmptyInventorySlots() > minEmptySlots and count() > 0 do
        local mouse,_ = movement.GetChestMouse(itemName)
        if mouse == nil then
            break
        end
        advance({mouse=mouse})
        advance({mouse={X=mouse.X, Y=mouse.Y,}})
    end
    pathing.HandleRecoloring(chestTile, itemName)
    advance({keyboard={Keys.E}})
end

function pathing.PullFromChests(chests, itemName, total)
    for i, chest in ipairs(chests.chests) do
        local count = pathing.CountChest(chest.loc, chest.chestTile, itemName)
        if count >= total then
            movement.WalkToTile(chest.walkTile, pathing.mouseTile(chest.chestTile))
            movement.OpenChest(chest.chestTile.X, chest.chestTile.Y)
            pathing.GetFromChestInventory(itemName, total)
            pathing.HandleRecoloring(chest.chestTile, itemName)
            advance({keyboard={Keys.E}})
            return
        end
    end
end

function pathing.GetSeeds(seedName)
    if not pathing.HaveItems(seedName, 999) then
        pathing.GoToFarm()
        movement.SwapToItem("Infinity Blade")
        printf('need to get %s', seedName)
        return pathing.CollectFromChest(chests.SafetySeedChest.walkTile, chests.SafetySeedChest.chestTile, seedName, 999)
    end
    return true
end

function pathing.DumpSeeds(seedName)
    local function safety()
        return pathing.CountChest("Farm", chests.SafetySeedChest.chestTile, seedName) < pathing.safetySeedCount
    end
    local function inventory()
        return pathing.CountInventory(seedName) > 0
    end
    pathing.GoToFarm()
    if safety() then
        movement.WalkToTile(chests.SafetySeedChest.walkTile, pathing.mouseTile(chests.SafetySeedChest.chestTile))
        movement.OpenChest(chests.SafetySeedChest.chestTile.X, chests.SafetySeedChest.chestTile.Y)
        while safety() and inventory() do
            local mouse,_ = movement.GetChestInventoryMouse(seedName)
            advance({mouse=mouse})
            advance()
        end
        advance({keyboard={Keys.E}})
    end
    if inventory() then
        movement.WalkToTile(chests.SeedChest.walkTile, pathing.mouseTile(chests.SeedChest.chestTile))
        movement.OpenChest(chests.SeedChest.chestTile.X, chests.SeedChest.chestTile.Y)
        while pathing.CountInventory(seedName) > 0 do
            local mouse,_ = movement.GetChestInventoryMouse(seedName)
            advance({mouse=mouse})
            advance()
        end
        advance({keyboard={Keys.E}})
    end
end

function pathing.DumpForageChest()
    pathing.GoToFarm()
    movement.WalkToTile(chests.ForageChest.walkTile, pathing.mouseTile(chests.ForageChest.chestTile))
    movement.OpenChest(chests.ForageChest.chestTile.X, chests.ForageChest.chestTile.Y)
    local seasonalForage = {
        "Daffodil",
        "Dandelion",
        "Leek",
        "Wild Horseradish",
        "Sweet Pea",
        "Spice Berry",
        "Grape",
        "Wild Plum",
        "Hazelnut",
        "Blackberry",
        "Common Mushroom",
        "Winter Root",
        "Crystal Fruit",
        "Snow Yam",
        "Crocus",
    }
    for _, v in ipairs(seasonalForage) do
        while pathing.CountInventory(v) > 0 do
            local mouse,_ = movement.GetChestInventoryMouse(v)
            advance({mouse=mouse})
            advance()
        end
    end
end

function pathing.OpenWorkbench()
    pathing.GoToFarm()
    movement.WalkToTile(chests.Workbench.walkTile, pathing.mouseTile(chests.Workbench.benchTile))
    movement.OpenChest(chests.Workbench.benchTile.X, chests.Workbench.benchTile.Y)
end


function pathing.CraftSeeds(craftingName)
    if Game1.activeClickableMenu == nil then
        advance({keyboard={Keys.Escape}})
    end
    if Game1.activeClickableMenu:GetType().Name == "CraftingPage" then
        pathing.MakeAll(Game1.activeClickableMenu, craftingName)
        advance({keyboard={Keys.Escape}})
        return
    end

    if Game1.activeClickableMenu:GetType().Name ~= "GameMenu" then
        advance({keyboard={Keys.E}})
    end
    if Game1.activeClickableMenu.currentTab ~= 4 then
        local pos =Game1.activeClickableMenu.tabs[4].bounds.Center
        advance({mouse={X=pos.X, Y=pos.Y, left=true}})
    end
    pathing.MakeAll(Game1.activeClickableMenu.pages[4], craftingName)
    advance({keyboard={Keys.Escape}})
end

function pathing.MakeAll(submenu, craftingName)
    local downButton = submenu.downButton.bounds.Center
    local recipes = CurrentMenu.CraftingPageRecipes
    if recipes == nil then
        return
    end
    local keyboard = {Keys.LeftControl, Keys.LeftShift}
    local craftButton = nil

    local currentCraftingPage = Reflector.GetDynamicCastField(submenu,"currentCraftingPage")
    while currentCraftingPage < submenu.pagesOfCraftingRecipes.Count do
        for i, k in list_items(recipes.Keys) do
            if k == craftingName then
                craftButton = submenu.currentPageClickableComponents[i].bounds.Center
                goto found
                break
            end
        end
        if currentCraftingPage+1 < submenu.pagesOfCraftingRecipes.Count then
            advance({mouse={X=downButton.X, Y=downButton.Y, left=true}, keyboard=keyboard})
            advance({keyboard=keyboard})
            recipes = CurrentMenu.CraftingPageRecipes
        else
            return
        end
    end
    ::found::
    if craftButton == nil then
        return
    end
    advance({keyboard=keyboard})
    while CurrentMenu.CraftingPageRecipes[craftingName] do
        if CurrentMenu.HeldItemStack > 900 then
            advance({keyboard=keyboard, mouse=movement.GetEmptyCraftingSlotMouse(submenu)})
            advance({keyboard=keyboard})
        end
        advance({keyboard=keyboard, mouse={X=craftButton.X, Y=craftButton.Y, left=true}})
        advance({keyboard=keyboard, mouse={X=craftButton.X, Y=craftButton.Y, left=false}})
    end
    if CurrentMenu.HeldItemStack > 0 then
        advance({keyboard=keyboard, mouse=movement.GetEmptyCraftingSlotMouse(submenu)})
        advance({keyboard=keyboard})
    end
end

function pathing.test()
    local t0 = os.clock()
    for i=1,10 do
        pathing.CountInventory("Staircase")
    end
    local t1 = os.clock()
    print(string.format("elapsed time: %f", t1 - t0))
    t0 = os.clock()
    local c = 0
    for i=1,10 do
        local inv = interface:CountInventory()
        if inv:ContainsKey("Staircase") then
            c = c + inv["Staircase"]
        end
    end
    t1 = os.clock()
    print(string.format("elapsed time: %f", t1 - t0))
end

return pathing