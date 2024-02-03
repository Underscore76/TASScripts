-- NOTES:
-- RNG call will be 0.90091120679905
-- tile will be floor(0.90091120679905 * NUM_TF) will be where the fairy will plant
-- first routing question: can you plant the initial number needed and then post-clear to get things
-- in the right order?
-- SO the way it fills in
-- it appends new results to the end of the list
-- if it DELETES, it will add new results into those indices that were previously deleted to backfill up to the orig capacity
-- so in theory you just need to hit the thing into the right slot at the start and it'll be there by the end
-- slotting into 227 start, number of ending terrain features can be between [243,253] to make it work (start is 224)

local movement = require('movement')
local pathing = require('pathing')
local fairy = {}

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function fairy.which()
    local n = 100
    local r = Random(Game1.uniqueIDForThisGame + Game1.stats.DaysPlayed)
    while n > 0 do
        n = n - 1
        if Game1.currentLocation.terrainFeatures:Count() ~= 0 then
            local rr = r:Copy()
            local idx = r:Next(Game1.currentLocation.terrainFeatures:Count())
            local t = Game1.currentLocation.terrainFeatures.Pairs:ElementAt(idx)
            if t.Value:GetType().Name == 'HoeDirt' then
                print({t.Key, idx, rr:NextDouble()})
                return t.Key
            end
        end
    end
    print('no target crop')
    return nil
end

function fairy.plan()
    -- can I programmatically create tiles to test? yes!
    -- Game1.currentLocation.terrainFeatures:Add(Vector2(63, 21), HoeDirt())
    -- Game1.currentLocation.terrainFeatures[Vector2(63,21)].crop = Crop(770,63,21)
    -- Game1.currentLocation.terrainFeatures:Remove(Vector2(63,21))
    -- get the mixed seeds if I wanted to do it manually
    -- Game1.player:addItemToInventory(SObject(770,39))
    local giantCropTiles = {
        Vector2(62,18), Vector2(63,18), Vector2(64,18), -- tl top
        Vector2(62,19), Vector2(63,19), Vector2(64,19), -- tl mid
        Vector2(62,20), Vector2(63,20), Vector2(64,20), -- tl bot
        Vector2(66,18), Vector2(67,18), Vector2(68,18), -- tr top
        Vector2(66,19), Vector2(67,19), Vector2(68,19), -- tr mid
        Vector2(66,20), Vector2(67,20), Vector2(68,20), -- tr bot
        Vector2(62,22), Vector2(63,22), Vector2(64,22), -- bl top
        Vector2(62,23), Vector2(63,23), Vector2(64,23), -- bl mid
        Vector2(62,24), Vector2(63,24), Vector2(64,24), -- bl bot
        Vector2(66,22), Vector2(67,22), Vector2(68,22), -- br top
        Vector2(66,23), Vector2(67,23), Vector2(68,23), -- br mid
        Vector2(66,24), Vector2(67,24), Vector2(68,24), -- br bot
    }
    local centerTile = Vector2(65,21) -- center
    local floatTiles = {
        Vector2(65,19), Vector2(65,20), -- up
        Vector2(65,22), Vector2(65,23), -- down
        Vector2(63,21), Vector2(64,21), -- left
        Vector2(66,21), Vector2(67,21), -- right
    }
    local frame = current_frame()
    local tiles = {}
    for i, tile in ipairs(giantCropTiles) do
        table.insert(tiles, tile)
    end
    for i, tile in ipairs(floatTiles) do
        if #tiles < 41 then
            table.insert(tiles, tile)
        end
    end
    -- basic result is that there are 224 starting terrain features
    -- planting 42 and removing as needed (14 minimum), at 
    tiles = shuffle(tiles)
    local dirt
    for i, tile in ipairs(tiles) do
        if Game1.currentLocation.terrainFeatures:Count() == 227 then
            dirt = HoeDirt()
            dirt.crop = Crop(770, centerTile.X, centerTile.Y)
            Game1.currentLocation.terrainFeatures:Add(centerTile, dirt)
        end
        dirt = HoeDirt()
        dirt.crop = Crop(770, tile.X, tile.Y)
        Game1.currentLocation.terrainFeatures:Add(tile, dirt)
    end
end

function fairy.tfs()
    for i, v in list_items(Game1.currentLocation.terrainFeatures.Pairs) do
        printf("%d %s", i, v.Key)
    end
end

return fairy