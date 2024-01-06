local overlays = require("overlays")
local movement = require("movement")
local pathing = require("pathing")
local slots = require("slots")

local chores = {
    minQiCoins = 1000000,
    minStone = 999*100,
    minFiber = 999*32,
    minWood = 999*32,
    minHardwood = 999*3,
    minFences = 2000,
    fenceBuy = 999*4,
    minSpeedgro = 600,
}

function chores.FlipWoodchippers()
    overlays.text_panel.set("Chore: Chip Hardwood")
    local numChippers = pathing.CountMachines("Cellar", "Wood Chipper")
    local item = "Hardwood"
    pathing.GoToCellar()
    if not pathing.HaveItems(item, numChippers) then
        -- print('need to get hardwood')
        pathing.CollectFromChest(
            pathing.chests.HardwoodChest.walkTile, 
            pathing.chests.HardwoodChest.chestTile, 
            item, numChippers)
    end
    advance()
    
    local f = movement.CollectThenDrop(item)
    local function frame_func()
        movement.SwapToItem(item)
        return f()
    end
    movement.WalkToTile(Vector2(2,7), frame_func)
    movement.WalkToTile(Vector2(2,14), frame_func)
    movement.WalkToTile(Vector2(5,15), frame_func)
    movement.WalkToTile(Vector2(8,15), frame_func)
    movement.WalkToTile(Vector2(11,15), frame_func)
    movement.WalkToTile(Vector2(14,15), frame_func)
    movement.WalkToTile(Vector2(17,15), frame_func)
    movement.WalkToTile(Vector2(17,8), frame_func)
    movement.WalkToTile(Vector2(14,7), frame_func)
    movement.WalkToTile(Vector2(14,7), frame_func)
    movement.WalkToTile(Vector2(4,7), frame_func)
    pathing.DumpToChest(
        pathing.chests.HardwoodChest.walkTile,
        pathing.chests.HardwoodChest.chestTile
    )
    chores.Overlay()
    pathing.GoToFarm()
    pathing.DumpToChest(
        pathing.chests.WoodChest.walkTile,
        pathing.chests.WoodChest.chestTile,
        "Wood"
    )
    chores.Overlay()
    overlays.text_panel.clear()
end

function chores.FlipJades()
    overlays.text_panel.set("Chore: Collect Jades")
    pathing.GoToFarmHouse()
    movement.SwapToItem("Jade")
    movement.WalkToTile(Vector2(2,21), movement.CollectNearby)
    movement.WalkToTile(Vector2(8,5), movement.CollectNearby)
    movement.WalkToTile(Vector2(16,7), movement.CollectNearby)
    movement.WalkToTile(Vector2(17,7), movement.CollectNearby)
    movement.WalkToTile(Vector2(16,5), movement.CollectNearby)
    movement.WalkToTile(Vector2(19,14), movement.CollectNearby)
    movement.WalkToTile(Vector2(31,17), movement.CollectNearby)
    movement.WalkToTile(Vector2(23,19), movement.CollectNearby)
    overlays.text_panel.clear()
end

function chores.DeconStairs()
    overlays.text_panel.set("Chore: Decon Stairs")
    local item = "Staircase"
    pathing.GoToFarmHouse()
    movement.SwapToItem(item)
    advance()
    local _collect = movement.CollectNearby
    local _collectdrop = movement.CollectThenDrop(item)
    local frame_func = function()
        if pathing.CountInventory(item) > 1 then
            return _collectdrop()
        end
        return _collect()
    end
    movement.WalkToTile(Vector2(32,32), frame_func)
    movement.WalkToTile(Vector2(24,30), frame_func)
    movement.WalkToTile(Vector2(28,22), frame_func)
    if movement.GetEmptyInventorySlots() < 6 then
        pathing.GoToDesert()
        pathing.DumpToChests(pathing.chests.StoneChests, "Stone")
        chores.Overlay()
    end
    overlays.text_panel.clear()
end

function chores.DeconFences()
    overlays.text_panel.set("Chore: Decon Fences")
    local numDecon = pathing.CountMachines("FarmHouse", "Deconstructor")
    local item = "Hardwood Fence"
    pathing.GoToFarmHouse()
    if not pathing.HaveItems(item, numDecon) then
        -- print('need to get fences')
        pathing.CollectFromChest(
            pathing.chests.FenceChest.walkTile, 
            pathing.chests.FenceChest.chestTile, 
            item, numDecon)
    end
    movement.SwapToItem("Hardwood Fence")
    advance()
    local frame_func = movement.CollectThenDrop(item)
    movement.WalkToTile(Vector2(32,32), frame_func)
    movement.WalkToTile(Vector2(24,30), frame_func)
    movement.WalkToTile(Vector2(28,22), frame_func)
    pathing.DumpToChest(
        pathing.chests.FenceChest.walkTile,
        pathing.chests.FenceChest.chestTile,
        "Hardwood Fence"
    )
    chores.Overlay()
    overlays.text_panel.clear()
end

function chores.HarvestIsland()
    overlays.text_panel.set("Chore: Ginger Island")
    local left = 71
    local right = 97
    local top = 44
    local bottom = 63
    pathing.GetSeeds("Summer Seeds")
    pathing.GoToIslandWest()
    local _harvest = movement.Harvest()
    local _plant = movement.Plant("Summer Seeds")
    local _retill = movement.Hoe()
    local _rewater = movement.Water()
    local function frame_func()
        local res = _harvest()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        res = _retill()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        res = _rewater()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        return _plant()
    end
    movement.SwapToItem("Infinity Blade")
    movement.WalkToTile(Vector2(98,45))
    local offset = 1
    while Game1.player:getTileLocation().X > left + offset do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    end
    while Game1.player:getTileLocation().Y < bottom - offset do
        movement.WalkCardinal(movement.DIR.DOWN, frame_func)
    end
    while Game1.player:getTileLocation().X < right - offset do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    offset = offset + 3
    while Game1.player:getTileLocation().Y > top + offset do
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    while Game1.player:getTileLocation().X > left + offset do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    end
    while Game1.player:getTileLocation().Y < bottom - offset do
        movement.WalkCardinal(movement.DIR.DOWN, frame_func)
    end
    while Game1.player:getTileLocation().X < right - offset do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    offset = offset+ 3
    while Game1.player:getTileLocation().X > left + offset do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    end
    movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    while Game1.player:getTileLocation().X < right - offset + 3 do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    -- UP, UP, RIGHT, UP, UP, LEFT, LEFT, LEFT, DOWN, 
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.UP, frame_func)
    movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    movement.WalkCardinal(movement.DIR.DOWN, frame_func)
    -- left left down left left up
    for i=0,2 do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
        movement.WalkCardinal(movement.DIR.DOWN, frame_func)
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    

    pathing.DumpForageChest()
    pathing.OpenWorkbench()
    local craftingName = "Wild Seeds (Su)"
    pathing.MakeAll(Game1.activeClickableMenu, craftingName)
    advance({keyboard={Keys.Escape}})
    pathing.DumpSeeds("Summer Seeds")
    overlays.text_panel.clear()
end

function chores.HarvestGreenhouse()
    overlays.text_panel.set("Chore: Greenhouse")
    pathing.GetSeeds("Summer Seeds")
    pathing.GoToGreenhouse()
    local _harvest = movement.Harvest()
    local _plant = movement.Plant("Summer Seeds")
    local function frame_func()
        local res = _harvest()
        if res.use ~= nil and res.use then
            return res
        end
        return _plant()
    end
    movement.SwapToItem("Infinity Blade")
    movement.WalkToTile(Vector2(10,20))
    -- Ux2, Rx4, Ux3, Lx6, Ux2, Rx6, Ux2, Lx9, Dx7, Rx3
    for i=0,1 do
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    for i=0,3 do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    for i=0,2 do
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    for i=0,5 do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    end
    for i=0,1 do
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    for i=0,5 do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    for i=0,1 do
        movement.WalkCardinal(movement.DIR.UP, frame_func)
    end
    for i=0,8 do
        movement.WalkCardinal(movement.DIR.LEFT, frame_func)
    end
    for i=0,6 do
        movement.WalkCardinal(movement.DIR.DOWN, frame_func)
    end
    for i=0,2 do
        movement.WalkCardinal(movement.DIR.RIGHT, frame_func)
    end
    pathing.DumpForageChest()
    pathing.OpenWorkbench()
    local craftingName = "Wild Seeds (Su)"
    pathing.MakeAll(Game1.activeClickableMenu, craftingName)
    advance({keyboard={Keys.Escape}})
    pathing.DumpSeeds("Summer Seeds")
    overlays.text_panel.clear()
end

function chores.ScytheGrass()
    overlays.text_panel.set("Chore: Scythe Grass")
    pathing.GoToFarm()
    movement.SwapToItem("Infinity Blade")
    local loc = CurrentLocation.NearestGrass()
    while loc ~= Vector2.Zero do

        local tile = Vector2(loc.X+1, loc.Y+1)
        if not Game1.currentLocation.Objects:ContainsKey(tile) then
            Controller.pathFinder:Update(tile.X, tile.Y, false)
            if Controller.pathFinder.hasPath then
                movement.WalkToTile(tile)
                local mouse = movement.GetMouseTileFromGlobal(loc.X+1, loc.Y)
                for i=0,1 do
                    advance({mouse=mouse})
                    mouse.left=true
                    advance({mouse=mouse})
                    advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
                end
                goto continue
            end
        end
        
        tile = Vector2(loc.X-1, loc.Y+1)
        if not Game1.currentLocation.Objects:ContainsKey(tile) then     
            Controller.pathFinder:Update(tile.X, tile.Y, false)
            if Controller.pathFinder.hasPath then
                movement.WalkToTile(tile)
                local mouse = movement.GetMouseTileFromGlobal(loc.X, loc.Y+1)
                for i=0,1 do
                    advance({mouse=mouse})
                    mouse.left=true
                    advance({mouse=mouse})
                    advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
                end
                goto continue
            end
        end

        ::continue::
        loc = CurrentLocation.NearestGrass()
    end
    overlays.text_panel.clear()
end

function chores.HarvestFarm()
    local seedNames = {
        spring={item="Spring Seeds",recipe="Wild Seeds (Sp)"},
        summer={item="Summer Seeds",recipe="Wild Seeds (Su)"},
        fall={item="Fall Seeds",recipe="Wild Seeds (Fa)"},
        winter={item="Winter Seeds",recipe="Wild Seeds (Wi)"}
    }

    if Game1.dayOfMonth == 1 then
        chores.ScytheGrass()
    end
    overlays.text_panel.set("Chore: Farm")
    local seedName = seedNames[Game1.currentSeason].item
    local craftingName = seedNames[Game1.currentSeason].recipe
    local foundSeeds = false
    if Game1.dayOfMonth ~= 28 then
        foundSeeds = pathing.GetSeeds(seedName)
        if not foundSeeds then
            local c = pathing.CountInventory(seedName)
            if c > 0 then
                foundSeeds = true
            end
        end
    else
        pathing.GoToFarm()
    end
    
    local _retill = movement.Hoe()
    local _pickaxe = movement.Pickaxe()
    local _axe = movement.Axe()
    local _harvest = movement.Harvest()
    local _plant = movement.Plant(seedName)
    local function frame_func()
        local res = _pickaxe()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        res = _axe()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        res = _retill()
        if res ~= nil and res.use ~= nil and res.use then
            return res
        end
        res = _harvest()
        if res.use ~= nil and res.use then
            return res
        end
        if foundSeeds then
            return _plant()
        else
            return {}
        end
    end
    
    movement.SwapToItem("Infinity Blade")
    local left_path = {
        "DOWN,2","LEFT,12","DOWN,3,","RIGHT,12","DOWN,4","LEFT,2","UP,1","LEFT,3","DOWN,1","LEFT,2","UP,1",
        "LEFT,3","DOWN,1","LEFT,2","UP,1","LEFT,2","DOWN,2","LEFT,1","DOWN,2","RIGHT,1","DOWN,1","LEFT,1","DOWN,2",
        "RIGHT,2","DOWN,4","RIGHT,4","UP,3","LEFT,1","UP,2","LEFT,1","UP,2","RIGHT,2","DOWN,1","RIGHT,3","UP,1",
        "RIGHT,2","DOWN,1","RIGHT,7","DOWN,3","LEFT,9","DOWN,3","RIGHT,9","DOWN,2","LEFT,2","DOWN,1","LEFT,10",
        "DOWN,3","RIGHT,11","DOWN,3","LEFT,4","UP,1","LEFT,2","DOWN,1","LEFT,3","UP,1","LEFT,3","DOWN,4",
        "RIGHT,22","DOWN,3","LEFT,25","DOWN,3","RIGHT,17","DOWN,3","LEFT,17","DOWN,4","RIGHT,3","UP,1",
        "RIGHT,3","DOWN,1","RIGHT,2","UP,1","RIGHT,3","DOWN,1","RIGHT,2","UP,1", "RIGHT,1",
    }
    movement.WalkToTile(Vector2(35,14))
    for i,v in ipairs(left_path) do
        local tokens = string.split(v,",")
        local dir = tokens[1]
        local count = tonumber(tokens[2])
        for i=0,count-1 do
            movement.WalkCardinal(movement.DIR[dir], frame_func)
        end
    end
    movement.WalkToTile(Vector2(39,58), pathing.mouseTile(Vector2(40,59)))
    advance()
    advance({keyboard={Keys.X}})
    local right_path = {
        "DOWN,2","RIGHT,4","DOWN,14","RIGHT,2","LEFT,5",
        "UP,11","LEFT,3","DOWN,11","LEFT,4","UP,2",
        "RIGHT,2","UP,3","LEFT,2","UP,2","RIGHT,2",
        "UP,3","LEFT,2","UP,2","RIGHT,2","UP,1",
        "RIGHT,1","UP,1","LEFT,3"
    }
    local failcount = 0
    while Game1.player:getTileLocation().X ~= 66 do
        advance()
        failcount = failcount + 1
        if failcount > 300 then
            print('failed to find tile')
            return
        end
    end
    movement.WalkToTile(Vector2(64,18))
    for i,v in ipairs(right_path) do
        local tokens = string.split(v,",")
        local dir = tokens[1]
        local count = tonumber(tokens[2])
        for i=0,count-1 do
            movement.WalkCardinal(movement.DIR[dir], frame_func)
        end
    end
    pathing.DumpForageChest()
    pathing.OpenWorkbench()
    pathing.MakeAll(Game1.activeClickableMenu, craftingName)
    advance({keyboard={Keys.Escape}})
    if not foundSeeds and Game1.dayOfMonth ~= 28 then
        chores.HarvestFarm()
    else
        pathing.DumpSeeds(seedName)
    end
    overlays.text_panel.clear()
end

function chores.ConsumeFood()
    overlays.text_panel.set("Chore: Consume Food")
    if pathing.CountInventory("Spicy Eel") > 1 then
        movement.SwapToItem("Spicy Eel")
        advance()
        advance({keyboard={Keys.X}})
        advance({keyboard={Keys.Y}})
        while not Game1.player.CanMove do
            advance()
        end
    end
    if pathing.CountInventory("Triple Shot Espresso") > 1 then
        movement.SwapToItem("Triple Shot Espresso")
        advance()
        advance({keyboard={Keys.X}})
        advance({keyboard={Keys.Y}})
        while not Game1.player.CanMove do
            advance()
        end
    end
    movement.SwapToItem("Infinity Blade")
    overlays.text_panel.clear()
end

function chores.TurnInJades()
    overlays.text_panel.set("Chore: Trade Jades")
    pathing.OpenDesertTrader()
    local nJades = pathing.CountInventory("Jade")
    if nJades > 1 then
        pathing.BuyItem("Staircase", nJades-1)
    end
    local nRuby = pathing.CountInventory("Ruby")
    if nRuby > 1 then
        pathing.BuyItem("Spicy Eel", nRuby-1)
    end
    local nDiamond = pathing.CountInventory("Diamond")
    if nDiamond > 1 then
        pathing.BuyItem("Triple Shot Espresso", nDiamond-1)
    end
    advance({keyboard={Keys.Escape}})
    advance()
    overlays.text_panel.clear()
end

function chores.Gamble()
    overlays.text_panel.set("Chore: Gamble")
    pathing.GoToCasino()
    movement.WalkToTile(Vector2(12,9))
    local tiles = {
        Vector2(14,9),
        Vector2(14,7),
        Vector2(13,7),
        Vector2(13,9),
    }
    local i = 1
    while Game1.player.clubCoins < chores.minQiCoins do
        slots.init(Vector2(13,8))
        while true do
            movement.WalkToTile(tiles[i], slots.step)
            if Game1.currentMinigame ~= nil then
                break
            end
            i = (i % 4) + 1
        end
        local spin100 = Reflector.GetDynamicCastField(Game1.currentMinigame, "spinButton100").bounds.Center
        local viewport = Game1.viewport
        advance({mouse={X=spin100.X+viewport.Y-32, Y=spin100.Y+viewport.X}})
        -- NO CLUE WHY IT WORKS THIS WAY
        advance({mouse={X=spin100.X+viewport.Y-32, Y=spin100.Y+viewport.X, left=true}})
        while Game1.currentMinigame ~= nil do
            advance()
            advance({keyboard={Keys.Escape}})
        end
    end
    overlays.text_panel.clear()
end

function chores.ReplenishFences()
    overlays.text_panel.set("Chore: Buy Fences")
    pathing.OpenCasinoStore()
    pathing.BuyItem("Hardwood Fence", chores.fenceBuy)
    pathing.GoToFarmHouse()
    pathing.DumpToChest(
        pathing.chests.FenceChest.walkTile,
        pathing.chests.FenceChest.chestTile,
        "Hardwood Fence"
    )
    chores.Overlay()
    overlays.text_panel.clear()
end

function chores.GoToBed()
    overlays.text_panel.set("Chore: Go To Bed")
    pathing.GoToFarmHouse()
    local tile = Game1.currentLocation:GetBed():GetBedSpot()
    local p = Game1.player:getTileLocation()
    if (
        (p.X == tile.X - 1 and p.Y == tile.Y)
        or (p.X == tile.X + 1 and p.Y == tile.Y)
    ) then
        -- in bed
    end
    if p.X <= tile.X and p.Y ~= tile.Y then
        movement.WalkToTile(Vector2(tile.X-2, tile.Y))
        movement.WalkCardinal(movement.DIR.RIGHT)
    else
        movement.WalkToTile(Vector2(tile.X+2, tile.Y))
        movement.WalkCardinal(movement.DIR.LEFT)
    end
    p = Game1.player:getTileLocation()
    if p.X < tile.X then
        movement.AdvanceUntilMenu(Keys.D)
    else
        movement.AdvanceUntilMenu(Keys.A)
    end
    advance()
    overlays.text_panel.clear()
end

function chores.NextTick()
    overlays.text_panel.set("Chore: Waiting...")
    if pathing.CountInventory("Clay") > 0 then
        movement.AdvanceUntilMenu(Keys.Escape,nil,true)
        local mouse = movement.GetInventoryMouse("Clay")
        advance({mouse=mouse})
        advance({keyboard={Keys.Delete}})
        advance({keyboard={Keys.Escape}})
    end
    local t = Game1.timeOfDay
    while Game1.timeOfDay == t do
        if Game1.currentLocation.Name ~= "FarmHouse" then
            pathing.GoToFarmHouse()
        end
        advance()
    end
end

function chores.CraftSaplings()
    overlays.text_panel.set("Chore: Craft Saplings")
    if Game1.activeClickableMenu == nil or Game1.activeClickableMenu.Name ~= "CraftingPage" then
        pathing.OpenWorkbench()
    end
    local craftingName = "Tea Sapling"
    pathing.MakeAll(Game1.activeClickableMenu, craftingName)
    advance({keyboard={Keys.Escape}})
    pathing.DumpToChests(pathing.chests.SaplingChests, craftingName)
    chores.Overlay()
    overlays.text_panel.clear()
end

function chores.TradeFiber()
    local n = pathing.CountMachineDoneItems("FarmHouse", "Deconstructor", "Stone")
    if n > 0 then
        -- go clear the decons
        chores.DeconStairs()
    end
    
    overlays.text_panel.set("Chore: Trade Fiber")
    local startChest = nil
    for i,v in ipairs(pathing.chests.StoneChests.chests) do
        if startChest == nil then
            startChest = v
        end
        while pathing.CountChest("Desert", v.chestTile, "Stone") > 5 do
            pathing.GoToDesert()
            local mouse = movement.GetMouseTileFromGlobal(v.chestTile.X, v.chestTile.Y)
            advance({mouse=mouse})
            pathing.PullFromChest(v.walkTile, v.chestTile, "Stone", 1)
            pathing.OpenDesertTrader()
            local count = pathing.CountInventory("Stone")
            if count > 5 then
                pathing.BuyItem("Fiber", count // 5)
            end
            advance({keyboard={Keys.Escape}})
            pathing.DumpToChest(startChest.walkTile, startChest.chestTile, "Fiber")
            chores.Overlay()
        end
    end
    while pathing.CountChest("Desert", startChest.chestTile, "Fiber") > 0 do
        pathing.GoToDesert()
        pathing.PullFromChest(startChest.walkTile, startChest.chestTile, "Fiber", 1)
        pathing.GoToFarm()
        pathing.DumpToChest(pathing.chests.FiberChest.walkTile, pathing.chests.FiberChest.chestTile, "Fiber")
        chores.Overlay()
    end
    pathing.GoToFarm()
    chores.CraftSaplings()
    overlays.text_panel.clear()
end

function chores.BackfillSpeedgro(numHave)
    overlays.text_panel.set("Chore: Buy Speed-Gro")
    -- go get the saplings to sell
    local numBuy = 23 * 999 - numHave
    local numSaplings = math.ceil((numBuy * 80 - Game1.player.Money) / 500)
    pathing.GoToFarm()
    pathing.PullFromChests(pathing.chests.SaplingChests, "Tea Sapling", numSaplings)
    pathing.OpenSeedShopStore()
    pathing.SellItem("Tea Sapling", numSaplings)
    pathing.OpenOasisStore()
    pathing.BuyItem("Deluxe Speed-Gro", numBuy)
    pathing.GoToIslandWest()
    local corner = Vector2(98,46)
    for j=0,3 do
        local dir = j % 2
        for i=0,5 do
            if dir == 0 then
                local tile = Vector2(corner.X - 5 * i, corner.Y + 5 * j)
                local moveTile = Vector2(tile.X - 1, tile.Y-1)
                if i == 5 then
                    moveTile = Vector2(tile.X+1, tile.Y-1)
                end
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    pathing.DumpToChest(moveTile, tile)            
                end
            else
                local tile = Vector2(corner.X + 5 * i - 25, corner.Y + 5 * j)
                local moveTile = Vector2(tile.X - 1, tile.Y-1)
                if i == 0 then
                    moveTile = Vector2(tile.X+1, tile.Y-1)
                end
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    pathing.DumpToChest(moveTile, tile)            
                end
            end
        end
    end
end

function chores.state()
    local nDecons = pathing.CountMachines("FarmHouse", "Deconstructor")
    local function saplingCount()
        local count = 0
        for i,v in ipairs(pathing.chests.SaplingChests.chests) do
            count = count + pathing.CountChest("Farm", v.chestTile, "Tea Sapling")
        end
        return count
    end
    local function woodCount()
        return pathing.CountChest("Farm", pathing.chests.WoodChest.chestTile, "Wood")
    end
    local function hardwoodCount()
        return (
            pathing.CountChest("Cellar", pathing.chests.HardwoodChest.chestTile, "Hardwood")
            + pathing.CountInventory("Hardwood")
        )
    end
    local function fenceCount()
        return pathing.CountChest("FarmHouse", pathing.chests.FenceChest.chestTile, "Hardwood Fence")
    end
    local function stoneCount()
        local count = 0
        for i,v in ipairs(pathing.chests.StoneChests.chests) do
            count = count + pathing.CountChest("Desert", v.chestTile, "Stone")
        end
        return count
    end
    local function fiberCount()
        return pathing.CountChest("Farm", pathing.chests.FiberChest.chestTile, "Fiber")
    end
    local function staircaseCount()
        return pathing.CountInventory("Staircase")
    end
    local function itsLATE()
        return (
            Game1.timeOfDay >= 2420
        )
    end
    local function addTime(x,y)
        while y > 0 do
            if y >= 60 then
                x = x + 100
                y = y - 60
            else
                x = x + 1
                y = y - 1
                if x % 100 >= 60 then
                    x = x + 40
                end
            end
        end
        return x
    end
    local function speedgroCount()
        local corner = Vector2(98,46)
        local minVal, sum = -1,0
        local loc = Game1.getLocationFromName("IslandWest")
        for i = 0,5 do
            for j=0,3 do
                local tile = Vector2(corner.X - 5 * i, corner.Y + 5 * j)
                if loc.Objects:ContainsKey(tile) then
                    local enricher = loc.Objects[tile].heldObject.Value.heldObject.Value
                    if enricher.items.Count > 0 then
                        local count = enricher.items[0].Stack
                        sum = sum + count
                        if minVal == -1 or count < minVal then
                            minVal = count
                        end
                    end
                end
            end
        end
        return minVal, sum
    end
    local function needsFood()
        local food = Game1.onScreenMenus[2].food
        local drink = Game1.onScreenMenus[2].drink
        return (food == nil or drink == nil) and Game1.timeOfDay < 800
    end
    local function tradeJades()
        local isNightMarket = Game1.currentSeason == "winter" and Game1.dayOfMonth == 16
        if isNightMarket then
            return false
        end
        return (
            pathing.CountInventory("Jade") > 100 
            and Game1.dayOfMonth % 7 == 0
            and stoneCount() < chores.minStone
        )
    end
    local function hasStaircases()
        if stoneCount() > chores.minStone then
            return false
        end
        return (
            (
                pathing.CountInventory("Staircase") > 1
                or pathing.CountMachineDoneItems("FarmHouse","Deconstructor","Stone") > 0
            )
        )
    end
    local function tradeFiber()
        if fiberCount() > chores.minFiber then
            return false
        end
        local isNightMarket = Game1.currentSeason == "winter" and Game1.dayOfMonth == 16
        if isNightMarket then
            return false
        end
        return (
            not hasStaircases() 
            and Game1.dayOfMonth % 7 == 2
            and stoneCount() > 0
        )
    end
    local function deconstructStaircase()
        if stoneCount() > chores.minStone then
            return false
        end
        return (
            pathing.CountMachinesDone("FarmHouse", "Deconstructor") >= nDecons-1
            and (
                hasStaircases()
                or pathing.CountMachineDoneItems("FarmHouse","Deconstructor","Stone") > 0
            )
        )
    end 
    local function chipperTime()
        local t = Game1.timeOfDay
        local n = Game1.getLocationFromName("Cellar").Objects[Vector2(3,6)].minutesUntilReady.Value
        return addTime(t,n)
    end
    local function deconTime()
        local t = Game1.timeOfDay
        local n = Game1.getLocationFromName("FarmHouse").Objects[Vector2(29,23)].minutesUntilReady.Value
        return addTime(t,n)
    end
    local function needWood()
        return (woodCount() < chores.minWood and chipperTime() < 1800)
    end
    local function deconstructFences()
        return (
            pathing.CountMachinesDone("FarmHouse", "Deconstructor") >= nDecons-1
            and pathing.CountChest("FarmHouse", pathing.chests.FenceChest.chestTile, "Hardwood Fence") > 100
            and hardwoodCount() < chores.minHardwood
        )
    end
    local function woodchippers()
        return (
            needWood()
            and hardwoodCount() > 150
            and pathing.CountMachinesDone("Cellar", "Wood Chipper") > 100
            and chipperTime() < 1800
        )
    end
    local function harvestIsland()
        return Game1.getLocationFromName("IslandWest").Objects:ContainsKey(Vector2(71,44))
    end
    local function harvestGreenhouse()
        return Game1.getLocationFromName("Greenhouse").Objects:ContainsKey(Vector2(4,10))
    end
    local function harvestFarm()
        local keys = {
            Vector2(60,20), 
            Vector2(22,15), Vector2(23,15), 
            Vector2(22,16), Vector2(23,16), 
            Vector2(22,17), Vector2(23,17), 
            Vector2(22,18), Vector2(23,18), 
            Vector2(22,19), Vector2(23,19), 
            Vector2(22,20), Vector2(23,20), 
            Vector2(22,21), Vector2(23,21), 
        }
        if 24 <= Game1.dayOfMonth and Game1.dayOfMonth < 28 then
            return false
        end
        local all = true
        local c = 0 
        for i,v in ipairs(keys) do
            if Game1.getLocationFromName("Farm").Objects:ContainsKey(v) then
            elseif Game1.getLocationFromName("Farm").terrainFeatures:ContainsKey(v) then
                local tf = Game1.getLocationFromName("Farm").terrainFeatures[v]
                if tf:GetType().Name == "HoeDirt" then
                    if tf.crop ~= nil and not tf.crop.dead.Value then
                        all = false
                    else
                        c = c + 1
                    end
                elseif tf:GetType().Name == "Grass" then
                end
            else
                all = Game1.dayOfMonth == 1
            end
        end
        if c == #keys and Game1.dayOfMonth == 28 then
            all = false
        end
        return all
    end
    local function flipJades()
        return (
            pathing.CountMachinesDone("FarmHouse", "Crystalarium", "Jade") > 100 
            and stoneCount() < chores.minStone
    )
    end
    local function casinoOpen()
        return Game1.timeOfDay >= 900 and Game1.timeOfDay < 2350
    end
    local function buyFences()
        return (
            fenceCount() < chores.minFences 
            and casinoOpen() 
            and Game1.currentLocation.Name == "Desert" 
            and Game1.timeOfDay < 1800
    )
    end
    
    local function shouldBackfillSpeedgro()
        local minVal, _ = speedgroCount()
        return (
            minVal < chores.minSpeedgro 
            and Game1.dayOfMonth % 7 == 4 
            and not Game1.isFestival() 
            and not harvestIsland() 
            and casinoOpen()
        )
    end
    local val = {
        flipJades = flipJades(),
        tradeJades = tradeJades(),
        tradeFiber = tradeFiber(),
        deconStair = deconstructStaircase(),
        deconFence = deconstructFences(),
        chippers = woodchippers(),
        island = harvestIsland(),
        greenhouse = harvestGreenhouse(), 
        farm = harvestFarm(),
        fences = buyFences(),
        goToBed = itsLATE(),
        hasStaircases = hasStaircases(),
        needWood = needWood(),
        backfillSpeedgro = shouldBackfillSpeedgro(),
    }
    local any = false
    for k,v in pairs(val) do
        any = any or v
    end
    val["any"] = any
    -- non-blocking results
    val.needsFood = needsFood()
    
    val.staircaseCount = staircaseCount()
    val.stoneCount = stoneCount()
    val.fiberCount = fiberCount()
    val.woodCount = woodCount()
    val.hardwoodCount = hardwoodCount()
    val.fenceCount = fenceCount()
    val.chipTime = chipperTime()
    val.deconTime = deconTime()
    val.saplingCount = saplingCount()
    val.speedgroMin, val.speedgroSum = speedgroCount()
    return val
end

function chores.Run()
    Game1.options.pinToolbarToggle = true -- probably should just do this in the savefile
    local val = chores.state()
    chores.Overlay(val)
    Controller.Console:Close()
    ::start::
    if not val["any"] then
        chores.GoToBed()
        val = chores.state()
    end
    while val["any"] do
        -- this is super high priority to continuity
        if val.goToBed then
            chores.GoToBed()
            goto continue
        end
        if val.needsFood then
            chores.ConsumeFood()
        end

        if val.fences then
            chores.Gamble()
            chores.ReplenishFences()
            goto continue
        end

        if val.flipJades then
            chores.FlipJades()
            goto continue
        end

        if val.deconStair then
            chores.DeconStairs()
            goto continue
        end
        if val.tradeFiber then
            chores.TradeFiber()
            goto continue
        end
        if val.deconFence then
            chores.DeconFences()
            goto continue
        end

        if val.chippers then
            chores.FlipWoodchippers()
            goto continue
        end
        if val.greenhouse then
            chores.HarvestGreenhouse()
            goto continue
        end
        if val.island then
            chores.HarvestIsland()
            goto continue
        end
        if val.backfillSpeedgro then
            chores.BackfillSpeedgro(val.speedgroSum)
            goto continue
        end
        if val.farm then
            chores.HarvestFarm()
            goto continue
        end
        if val.tradeJades then
            chores.TurnInJades()
            goto continue
        end
        if val.hasStaircases or val.needWood then 
            chores.NextTick()
            goto continue
        end
        ::continue::
        val = chores.state()
        chores.Overlay(val)
        if not val["any"] then
            chores.GoToBed()
            val = chores.state()
        end
    end
    goto start
    Controller.Console:Open()
end

-- function chores.Test()
--     local n = pathing.CountMachineDoneItems("FarmHouse", "Deconstructor", "Stone")
--     if n > 0 then
--         -- go clear the decons
--         chores.DeconStairs()
--     end
    
--     local startChest = nil
--     for i,v in ipairs(pathing.chests.StoneChests.chests) do
--         if startChest == nil then
--             startChest = v
--         end
--         print(v)
--         while pathing.CountChest("Desert", v.chestTile, "Stone") > 0 do
--             pathing.GoToDesert()
--             pathing.PullFromChest(v.walkTile, v.chestTile, "Stone", 1)
--             pathing.OpenDesertTrader()
--             local count = pathing.CountInventory("Stone")
--             if count > 0 then
--                 pathing.BuyItem("Fiber", count//5)
--             end
--             advance({keyboard={Keys.Escape}})
--             pathing.DumpToChest(startChest.walkTile, startChest.chestTile, "Fiber")
--             chores.Overlay()
--         end
--     end
--     while pathing.CountChest("Desert", startChest.chestTile, "Fiber") > 0 do
--         pathing.GoToDesert()
--         pathing.PullFromChest(startChest.walkTile, startChest.chestTile, "Fiber", 1)
--         pathing.GoToFarm()
--         pathing.DumpToChest(pathing.chests.FiberChest.walkTile, pathing.chests.FiberChest.chestTile, "Fiber")
--         chores.Overlay()
--     end
--     pathing.GoToFarm()
--     chores.CraftSaplings()
-- end

function chores.Play()
    breset(300)
    chores.Run()
end
-- frame 161816
function chores.Overlay(val)
    if val == nil then
        val = chores.state()
    end
    Controller.Overlays["ItemCounters"]:Update(251, val.saplingCount)
    Controller.Overlays["ItemCounters"]:Update(771, val.fiberCount)
    Controller.Overlays["ItemCounters"]:Update(390, val.stoneCount)
    Controller.Overlays["ItemCounters"]:Update(388, val.woodCount)
    Controller.Overlays["ItemCounters"]:Update(709, val.hardwoodCount)
    Controller.Overlays["ItemCounters"]:Update(298, val.fenceCount)
end

function chores.Test()
    
end

return chores
