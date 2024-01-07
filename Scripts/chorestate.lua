local pathing = require('pathing')

local function saplingCount()
    local count = 0
    for i,v in ipairs(pathing.chests.SaplingChests.chests) do
        local c = pathing.CountChest("Farm", v.chestTile, "Tea Sapling")
        count = count + c
        if c == 0 then
            return count
        end
    end
    return count
end

local function woodCount()
    return pathing.CountChest("Farm", pathing.chests.WoodChest.chestTile, "Wood")
end

local function hardwoodCount(inventory)
    local count = pathing.CountChest("Cellar", pathing.chests.HardwoodChest.chestTile, "Hardwood")
    count = count + pathing.CountInventory("Hardwood")
    return count
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

local function needFoodBuff()
    local food = Game1.onScreenMenus[2].food
    return food == nil and Game1.timeOfDay < 1700
end

local function needDrinkBuff()
    local drink = Game1.onScreenMenus[2].drink
    return drink == nil and Game1.timeOfDay < 800
end

local function casinoOpen()
    return Game1.timeOfDay >= 900 and Game1.timeOfDay < 2350
end

local function gen_state()
    local t0 = os.clock()
    local speedgroMin, speedgroSum = speedgroCount()
    -- local inventory = pathing:CountInventory()
    local deconState = interface:GetMachineState("FarmHouse","Deconstructor")
    local lariumState = interface:GetMachineState("FarmHouse","Crystalarium")
    local chipperState = interface:GetMachineState("Cellar","Wood Chipper")
    local state = {
        saplingCount = saplingCount(),
        woodCount = woodCount(),
        hardwoodCount = hardwoodCount(),
        fenceCount = fenceCount(),
        stoneCount = stoneCount(),
        fiberCount = fiberCount(),
        staircaseCount = pathing.CountInventory("Staircase"),
        speedgroMin = speedgroMin,
        speedgroSum = speedgroSum,
        needFoodBuff = needFoodBuff(),
        needDrinkBuff = needDrinkBuff(),
        numDecons = deconState.NumMachine,
        numChipper = chipperState.NumMachine,
        numLarium = lariumState.NumMachine,
        deconState = deconState,
        chipperState = chipperState,
        lariumState = lariumState,
        -- inventory = inventory,
        casinoOpen = casinoOpen(),
        numJade = pathing.CountInventory("Jade")

    }
    function state.DeconItem(name)
        if state.deconState.ItemCounts:ContainsKey(name) then
            return state.deconState.ItemCounts[name]
        end
        return 0
    end
    local t1 = os.clock()
    print("gen_state took "..(t1-t0).." seconds")
    return state
end

return gen_state