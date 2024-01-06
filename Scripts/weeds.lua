local game1 = require('game1')
local weeds = {hasHat=false, verbose=false}


-- function weeds.estimate_drop(r)
--     local toDrop = -1
--     if r:NextDouble() < 0.5 then
--         toDrop = 771
--     elseif r:NextDouble() < 0.05 then
--         toDrop = 770
--     end
--     for i = 1, 6 do
--         r:NextDouble() -- sprites
--     end
--     weeds.hasHat = (r:NextDouble() < 1e-5) or weeds.hasHat

--     r:NextDouble() -- qi beans
--     if toDrop ~= -1 then
--         -- print(Runner.gamePtr.game1.objectInformation[toDrop])
--         r:NextDouble() -- object.Flipped
--         -- guid gen
--         for i = 1, 8 do
--             r:NextDouble()
--         end
--     end
--     r:NextDouble() -- frog

--     if toDrop ~= -1 then
--         return Game1.objectName(toDrop)
--     end
--     return nil
-- end
function weeds.get_drop(random)
    if random == nil then
        random = game1.random()
    end
    local toDrop = nil
    if random:NextDouble() < 0.5 then
        toDrop = "Fiber"
    elseif random:NextDouble() < 0.05 then
        toDrop = "Mixed Seeds"
    end
    for i=1,6 do
        random:NextDouble() -- sprites
    end
    weeds.hasHat = (random:NextDouble() < 1e-5) or weeds.hasHat
    random:NextDouble() -- qi beans
    if toDrop ~= nil then
        -- print(Runner.gamePtr.game1.objectInformation[toDrop])
        random:NextDouble() -- object.Flipped
    end
    random:NextDouble() -- frog
    return toDrop
end

function weeds.get_drops(num_weeds, random)
    if random == nil then
        random = game1.random()
    end
    if num_weeds == nil then
        num_weeds = 1
    end
    random:NextDouble()
    random:NextDouble()
    weeds.hasHat = false
    local drops = {
        ["Fiber"] = 0, -- fiber
        ["Mixed Seeds"] = 0  -- mixed seeds
    }
    for i=1,num_weeds do
        local d = weeds.get_drop(random)
        if d ~= nil then
            drops[d] = drops[d] + 1
        end
    end
    drops['hat'] = weeds.hasHat
    return drops
end

function weeds.invert(num_weeds, num_fiber, num_mixed)
    local r = game1.random()
    for i=0,30 do
        local d = weeds.get_drops(num_weeds, copy_random(r))
        if d['Fiber'] == num_fiber and d['Mixed Seeds'] == num_mixed then
            printf('offset: %d', i)
            return
        end
        r:NextDouble()
    end
    print('unknown offset')
end

function weeds.search_hat_offset(num_weeds, max_scan)
    if num_weeds == nil then
        num_weeds = 1
    end
    if max_scan == nil then
        max_scan = 10000
    end
    local r = game1.random()
    for i=0,max_scan do
        local drops = weeds.get_drops(num_weeds, copy_random(r))
        if drops['hat'] then
            printf('FOUND HAT: offset %d', i)
            return
        end
        r:NextDouble()
    end
    printf('not within %d checks', max_scan)
end

return weeds

-- local weeds = { hasHat = false, verbose = false }

-- function weeds.estimate(num_weeds)
--     weeds.hasHat = false
--     local random = Game1.random()
--     if CurrentLocation.Name == "Farm" then
--         random:NextDouble()
--         random:NextDouble()
--     end
--     local drops = {
--         ["Mixed Seeds"] = 0,
--         ["Fiber"] = 0
--     }
--     for i = 1, num_weeds do
--         local d = weeds.estimate_drop(random)
--         if d ~= nil then
--             if weeds.verbose then
--                 print(string.format('weed %d: %s', i, d))
--             end
--             drops[d] = drops[d] + 1
--         end
--     end
--     return drops
-- end

-- function weeds.wait(num_weeds, num_mixed, max_frames)
--     function _print(f, t)
--         print(f)
--         print(t)
--     end

--     if num_weeds == nil then
--         num_weeds = 1
--     end
--     if num_mixed == nil or num_mixed > num_weeds then
--         num_mixed = num_weeds
--     end
--     if max_frames == nil then
--         max_frames = 20
--     end
--     local drops = {}
--     for i = 1, max_frames do
--         drops = weeds.estimate(num_weeds)
--         if len(drops) > 0 then
--             _print(GetCurrentFrame(), drops)
--         end
--         if drops['Mixed Seeds'] == num_mixed then
--             print("success")
--             return
--         end
--         advance()
--     end
--     drops = weeds.estimate(num_weeds)
--     if len(drops) > 0 then
--         _print(GetCurrentFrame(), drops)
--     end
-- end

-- function weeds.get_hat(num_weeds, max_frames)
--     if num_weeds == nil then
--         num_weeds = 1
--     end
--     if max_frames == nil then
--         max_frames = 100
--     end
--     for i = 1, max_frames do
--         weeds.estimate(num_weeds)
--         if weeds.hasHat then
--             print("FOUND HAT")
--             return
--         end
--         advance()
--     end
-- end

-- function weeds.debris()
--     local x = Inspect("Game1.currentLocation.debris")
--     for v in list_items(x) do
--         if v.debrisType:ToString() == "OBJECT" then
--             print(string.format("%s\t%s", v.Chunks[0].position.Value:ToString(), v.chunksMoveTowardPlayer))
--         end
--     end
-- end

-- return weeds