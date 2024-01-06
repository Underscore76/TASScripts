local seeding = {
    daysPlayed=29
}
function seeding.init()
    if Game1.currentLocation == nil then
        fload('default_loader')
        error("Please rerun now that loaded in.")
    end
    while Game1.activeClickableMenu == nil do
        advance({keyboard={Keys.Escape, Keys.A}})
        advance({keyboard={Keys.A}})
    end
end

-- function seeding.overwrite(seed, day)
--     Game1.uniqueIDForThisGame = seed
--     Game1.stats.daysPlayed = day
--     TileHighlight.Clear()
-- end

-- function seeding.volcanoRockNut(tx, ty)
--     local r = Random(Game1.stats.DaysPlayed + Game1.uniqueIDForThisGame // 2 + tx * 4000 + ty)
--     return r:NextDouble() < 0.03
-- end

-- function seeding.barrelNut(tx, ty)
--     local r = Random(tx + ty * 10000 + Game1.stats.DaysPlayed)
--     return r:NextDouble() >= 0.2 and r:NextDouble() < 0.1
-- end

-- function seeding.musselNut(tx, ty)
--     -- can be seeded mid-run by step maniping the spawn
--     local r = Random(Game1.stats.DaysPlayed + Game1.uniqueIDForThisGame // 2 + tx * 4000 + ty)
--     r:Next(2,5) -- number of mussels
--     return r:NextDouble() < 0.1 
-- end

-- function seeding.MinFish()
--     local count = 5
--     local itr = 0
--     while count > 0 do
--         itr = itr + 1
--         local r = Random(Game1.stats.DaysPlayed + itr + Game1.uniqueIDForThisGame):NextDouble() < 0.15
--         if r then
--             count = count - 1
--         end
--     end
--     return itr
-- end

-- function seeding.hp()
--     Game1.player.health = 50000000
-- end
-- function seeding.clr()
--     TileHighlight.Clear()
-- end

-- function seeding.hi()
--     TileHighlight.Clear()
--     for tile,obj in dict_items(Game1.currentLocation.Objects) do
--         if obj.Name == "Barrel" then
--             if seeding.barrelNut(tile.X, tile.Y) then
--                 TileHighlight.Add(tile)
--                 printf("Breakable at %d,%d (%d)", tile.X, tile.Y, Reflector.GetDynamicCastField(obj,"containerType").Value)
--             end
--         elseif obj.Name == "Stone" then
--             if Game1.currentLocation.Name == "IslandWest" then
--                 if obj.parentSheetIndex.Value == 25 and seeding.musselNut(tile.X, tile.Y) then
--                     TileHighlight.Add(tile)
--                     printf("Mussel at %d,%d", tile.X, tile.Y)
--                 end    
--             elseif seeding.volcanoRockNut(tile.X, tile.Y) then
--                 TileHighlight.Add(tile)
--                 printf("Nut at %d,%d", tile.X, tile.Y)
--             end
--         end 
--     end
-- end

-- function seeding.validChest(chest)
--     for i,item in list_items(chest.items) do
--         if item.Name == "Dwarf Hammer" or item.Name == "Dragontooth Club" then
--             return true
--         end
--     end
--     return false
-- end

-- function seeding.validLevel1()
--     local loc = interface:SpawnDungeon(1, Game1.stats.daysPlayed, Game1.uniqueIDForThisGame)
--     local count = 0
--     local validChest = false
--     for tile,obj in dict_items(loc.Objects) do
--         if obj.Name == "Chest" then
--             if seeding.validChest(obj) then
--                 validChest = true
--             end
--             count = count + 1
--         elseif obj.Name == "Barrel" then
--             if seeding.barrelNut(tile.X, tile.Y) then
--                 count = count + 1
--                 -- printf("Breakable at %d,%d", tile.X, tile.Y)
--             end
--         elseif obj.Name == "Stone" then
--             if seeding.volcanoRockNut(tile.X, tile.Y) then
--                 count = count + 1
--                 -- printf("Nut at %d,%d", tile.X, tile.Y)
--             end
--         end
--     end
--     loc = nil

--     return validChest, count
-- end

-- function seeding.test(seed, day)
--     seeding.overwrite(seed, day)
--     local validChest, count = seeding.validLevel1()
--     printf("%d\t%s\t%d", seed, validChest, count)
--     return validChest and count > 3
-- end

-- -- function seeding.test(seed, day)
-- --     seeding.overwrite(seed, day)
-- --     local count = 0
-- --     local loc = interface:SpawnDungeon(1, Game1.stats.daysPlayed, Game1.uniqueIDForThisGame)
-- --     -- interface:ScreenshotLocation(loc, "dungeon_"..Game1.stats.daysPlayed.."_"..Game1.uniqueIDForThisGame.."_"..1)
-- --     for tile,obj in dict_items(loc.Objects) do
-- --         if obj.Name == "Chest" then
-- --             -- 223 is normal chest - first try always
-- --             -- 227 is rare chest - first try always
-- --             printf("Chest at %d,%d (%d) %s", tile.X, tile.Y, obj.bigCraftableSpriteIndex.Value, obj.dropContents.Value)
-- --             if seeding.validChest(obj) then
-- --                 for i,item in list_items(obj.items) do
-- --                     printf("  %s", item.Name)
-- --                 end
-- --             end
-- --             count = count + 1
-- --         elseif obj.Name == "Barrel" then
-- --             if seeding.barrelNut(tile.X, tile.Y) then
-- --                 count = count + 1
-- --                 printf("Breakable at %d,%d", tile.X, tile.Y)
-- --             end
-- --         elseif obj.Name == "Stone" then
-- --             if seeding.volcanoRockNut(tile.X, tile.Y) then
-- --                 count = count + 1
-- --                 printf("Nut at %d,%d", tile.X, tile.Y)
-- --             end
-- --         end 
-- --     end
-- --     printf("Found %d nuts", count)
-- --     return count
-- -- end

-- function seeding.loop(first, last, block_size)
--     if first == nil then
--         first = 0
--     end
--     if last == nil then
--         last = 1000
--     end
--     seeding.init()
--     exec("clr")
--     local t0 = os.clock()
--     for seed=first,last-1,block_size do
        
--         for i=0,block_size-1,2 do
--             seeding.test(seed+i, seeding.daysPlayed)
--             -- if  then
--                 -- local loc = interface:SpawnDungeon(1, seeding.daysPlayed, seed+i)
--                 -- interface:ScreenshotLocation(loc, "dungeon_"..seeding.daysPlayed.."_"..seed+i.."_1")
--             -- end
--         end
--         advance()
--         Controller.Console:WriteToFile(first.."_"..last)
--     end
--     local t1 = os.clock()
--     print("Elapsed time: " .. t1 - t0 .. " seconds. Per Second: " .. (last-first) / (t1 - t0))
-- end

-- function seeding.b(idx)
--     local per_instance = 1 << 24
--     local block_size = 1 << 16
--     local first = idx * per_instance
--     local last = first + per_instance
--     seeding.loop(first, last, block_size)
-- end

function seeding.a(idx)
    if idx == nil then
        idx = 0
    end
    push()
    seeding.init();
    local t0 = os.clock()
    Seeding.TotalSize = 1 << 16
    Seeding.BlockSize = 1 << 12
    Seeding.Run(idx);
    local t1 = os.clock()
    print("Elapsed time: " .. t1 - t0 .. " seconds")
    brw()
    GC.Collect()
    Game1.currentSong:Stop(AudioStopOptions.Immediate)
end

return seeding