local Farm = luanet.import_type("StardewValley.Farm")
local SObject = luanet.import_type("StardewValley.Object")
local Tree = luanet.import_type("StardewValley.TerrainFeatures.Tree")
local Grass = luanet.import_type("StardewValley.TerrainFeatures.Grass")
local HoeDirt = luanet.import_type("StardewValley.TerrainFeatures.HoeDirt")
local Bush = luanet.import_type("StardewValley.TerrainFeatures.Bush")
local Crop = luanet.import_type("StardewValley.Crop")
local ResourceClump = luanet.import_type("StardewValley.TerrainFeatures.ResourceClump")
local ENTITY_CONSTRUCTORS = {
    Farm=Farm,
    Object=SObject,
    Tree=Tree,
    Grass=Grass,
    HoeDirt=HoeDirt,
    Bush=Bush,
    ResourceClump=ResourceClump
}
local clone = {}

function clone.LocationFromName(name)
    if ENTITY_CONSTRUCTORS[name] == nil then
        print('couldnt find '..name)
        print(ENTITY_CONSTRUCTORS)
        return nil
    end
    local loc = Game1.getLocationFromName(name)
    if loc == nil then
        return nil
    end
    local r = Game1.random:Copy()
    local pr = SleepInfo.PostWeatherRandom:Copy()
    local dayOfMonth = Game1.dayOfMonth
    local currentSeason = Game1.currentSeason
    local year = Game1.year
    local stats_DaysPlayed = Game1.stats.DaysPlayed
    local weatherForTomorrow = Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).weatherForTomorrow.Value
    local isRaining = Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isRaining.Value
    local isSnowing = Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isSnowing.Value
    local isLightning = Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isLightning.Value
    local isDebrisWeather = Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isDebrisWeather.Value
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isRaining.Value = weatherForTomorrow == 1 or weatherForTomorrow == 3
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isSnowing.Value = weatherForTomorrow == 5
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isLightning.Value = weatherForTomorrow == 3
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isDebrisWeather.Value = weatherForTomorrow == 2
    Game1.stats.DaysPlayed = Game1.stats.DaysPlayed+1
    
    Game1.dayOfMonth = Game1.dayOfMonth+1
    if Game1.dayOfMonth == 29 then
        if currentSeason == "spring" then
            Game1.currentSeason = "summer"
        elseif currentSeason == "summer" then
            Game1.currentSeason = "fall"
        elseif currentSeason == "fall" then
            Game1.currentSeason = "winter"
        elseif currentSeason == "winter" then
            Game1.currentSeason = "spring"
            Game1.year = Game1.year + 1
        end
        Game1.dayOfMonth = 1
    end
    
    local entity = ENTITY_CONSTRUCTORS[name](loc.mapPath.Value, loc.name.Value)
    clone.CopyObjects(entity, loc)
    Game1.random = pr
    printf("Before day update farm: %s", tostring(Game1.random))
    entity:DayUpdate(Game1.dayOfMonth)
    printf("After day update farm: %s", tostring(Game1.random))
    Game1.random = r
    Game1.dayOfMonth = dayOfMonth
    Game1.currentSeason = currentSeason
    Game1.year = year
    Game1.stats.DaysPlayed = stats_DaysPlayed
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isRaining.Value = isRaining
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isSnowing.Value = isSnowing
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isLightning.Value = isLightning
    Game1.netWorldState.Value:GetWeatherForLocation(GameLocation.LocationContext.Default).isDebrisWeather.Value = isDebrisWeather
    return entity
end

function clone.CopyObject(old)
    local objName = old:GetType().Name
    local constructor = ENTITY_CONSTRUCTORS[objName]
    if constructor == nil then
        print('couldnt find '..objName)
        print(ENTITY_CONSTRUCTORS)
        return nil
    end
    local new = constructor(old.tileLocation.Value, old.ParentSheetIndex, 1)
    -- new:reloadSprite()
    new.flipped.Value = old.flipped.Value
    return new
end

function clone.CopyCrop(old, tile)
    local crop = nil
    if old == nil then
        return crop
    end
    if old.forageCrop.Value then
        crop = Crop(old.forageCrop.Value, old.whichForageCrop.Value, tile.X, tile.Y)
    else
        crop = Crop(old.indexOfHarvest.Value, tile.X, tile.Y)
    end
    crop.flip.Value = old.flip.Value
    crop.dayOfCurrentPhase.Value = old.dayOfCurrentPhase.Value
    crop.currentPhase.Value = old.currentPhase.Value
    crop.phaseToShow.Value = old.phaseToShow.Value
    crop.dead.Value = old.dead.Value
    crop.fullyGrown.Value = old.fullyGrown.Value
    crop.indexOfHarvest.Value = old.indexOfHarvest.Value
    crop.netSeedIndex.Value = old.netSeedIndex.Value
    return crop
end

function clone.CopyTerrainFeature(old, tile, loc)
    local objName = old:GetType().Name
    local constructor = ENTITY_CONSTRUCTORS[objName]
    if constructor == nil then
        print('couldnt find '..objName)
        print(ENTITY_CONSTRUCTORS)
        return nil
    end
    local new = nil
    if objName == "Tree" then
        new = constructor(old.treeType.Value, old.growthStage.Value)
        new.flipped.Value = old.flipped.Value
    elseif objName == "Grass" then
        new = constructor(old.grassType.Value, old.numberOfWeeds.Value)
        for i,field in ipairs({"whichWeed", "offset1", "offset2", "offset3", "offset4", "flip", "shakeRandom"}) do
            local n = Reflector.GetDynamicCastField(new, field)
            local o = Reflector.GetDynamicCastField(old, field)
            for i=0,3 do
                n[i] = o[i]
            end
        end
    elseif objName == "HoeDirt" then
        local crop = clone.CopyCrop(old.crop, tile)
        new = constructor(old.state.Value, loc)
        new.crop = crop
    else
        return nil
    end
    
    return new
end

function clone.CopyLargeTerrainFeature(old, loc)
    local objName = old:GetType().Name
    local constructor = ENTITY_CONSTRUCTORS[objName]
    if constructor == nil then
        print('couldnt find '..objName)
        print(ENTITY_CONSTRUCTORS)
        return nil
    end
    local new = nil
    if objName == "Bush" then
        new = constructor(old.tilePosition.Value, old.size.Value, loc)
    else
        return nil
    end
    new.flipped.Value = old.flipped.Value
    return new
end

function clone.CopyResourceClump(old)
    local objName = old:GetType().Name
    local constructor = ENTITY_CONSTRUCTORS[objName]
    if constructor == nil then
        print('couldnt find '..objName)
        print(ENTITY_CONSTRUCTORS)
        return nil
    end
    local new = constructor(old.parentSheetIndex.Value, old.width.Value, old.height.Value, old.tile.Value)
    return new
end

local function duplicateObjects(new, old)
    -- NOTE: this is a hack to get around the fact that dictionary insertion order is not preserved
    -- need to be able to initialize the dict in the correct sequence so we take a fresh copy of the map
    -- and then nuke any features in that fresh map not in the current (preserving initialization)
    -- and then we can copy over the remaining features
    local remove_objects = {}
    for k,v in dict_items(new.netObjects) do
        if not old.Objects:ContainsKey(k) then
            printf("removing from new %d, %d, %s", k.X, k.Y, v.Name)
            table.insert(remove_objects, k)
        end
    end
    for _,k in ipairs(remove_objects) do
        new.Objects:Remove(k)
    end
    -- overwrite existing objects/add new objects
    for k,v in dict_items(old.netObjects) do
        -- printf("copying %d, %d, %s", k.X, k.Y, v.Name)
        local o = clone.CopyObject(v)
        if o ~= nil then
            if new.Objects:ContainsKey(k) then
                -- print('adding as clone over')
                new.Objects[k] = o
            else
                -- print('adding as new')
                new.Objects:Add(k, o)
            end
        end
    end
end

local function duplicateTerrainFeatures(new, old)
    -- NOTE: this is a hack to get around the fact that dictionary insertion order is not preserved
    -- need to be able to initialize the dict in the correct sequence so we take a fresh copy of the map
    -- and then nuke any features in that fresh map not in the current (preserving initialization)
    -- and then we can copy over the remaining features
    local remove_objects = {}
    for k,v in dict_items(new.terrainFeatures) do
        if not old.terrainFeatures:ContainsKey(k) then
            printf("removing from new %d, %d, %s", k.X, k.Y, v.Name)
            table.insert(remove_objects, k)
        end
    end
    for _,k in ipairs(remove_objects) do
        new.terrainFeatures:Remove(k)
    end
    -- overwrite existing objects/add new objects
    for k,v in dict_items(old.terrainFeatures) do
        -- printf("copying %d, %d, %s", k.X, k.Y, v.Name)
        local o = clone.CopyTerrainFeature(v, k, new)
        if o ~= nil then
            if new.terrainFeatures:ContainsKey(k) then
                -- print('adding as clone over')
                new.terrainFeatures[k] = o
            else
                -- print('adding as new')
                new.terrainFeatures:Add(k, o)
            end
        end
    end
end

function clone.CopyObjects(new, old)
    duplicateObjects(new, old)
    duplicateTerrainFeatures(new, old)

    new.largeTerrainFeatures:Clear()
    for _,v in list_items(old.largeTerrainFeatures) do
        local tf = clone.CopyLargeTerrainFeature(v, new)
        if tf ~= nil then
            new.largeTerrainFeatures:Add(tf)
        end
    end
    new.resourceClumps:Clear()
    for _,v in list_items(old.resourceClumps) do
        local rc = clone.CopyResourceClump(v)
        if rc ~= nil then
            new.resourceClumps:Add(rc)
        end
    end
end

return clone