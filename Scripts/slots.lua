local movement = require('movement')
local slots = {
    last_rng=nil,
    threshold=nil,
    tile=nil
}

local function advance_rng(r, n)
    local r2 = r:Copy()
    for i=1,n do
        r2:NextDouble()
    end
    return r2
end

function slots.init(tile)
    slots.threshold = (1.0 + Game1.player.DailyLuck * 2.0 + Game1.player.LuckLevel * 0.08) * 0.001
    slots.last_rng = game1_random():get_Index()
    slots.tile = tile
end

function slots.step()
    local r = game1_random():get_Index()
    local diff = r - slots.last_rng
    if diff == 0 then
        -- just mouse over the slot machine
        return {
            override_keyboard=false,
            mouse=movement.GetMouseTileFromGlobal(slots.tile.X,slots.tile.Y)
        }
    end
    slots.last_rng = r
    -- lookahead the diff and see if we match the jackpot
    local roll = advance_rng(game1_random(), diff+4):NextDouble()
    if roll < slots.threshold then
        -- force an advance into the minigame
        advance({keyboard={Keys.X}})
        if game1_random():NextDouble() >= slots.threshold then
            print('found a bad state')
            while Game1.currentMinigame ~= nil do
                advance()
                advance({keyboard={Keys.Escape}})
            end
            return {
                override_keyboard=false,
                mouse=movement.GetMouseTileFromGlobal(slots.tile.X,slots.tile.Y)
            }
        end
        print('found a good state')
        return {kill=true}
    end
    -- just mouse over the slot machine
    return {
        override_keyboard=false,
        mouse=movement.GetMouseTileFromGlobal(slots.tile.X,slots.tile.Y)
    }
end



return slots