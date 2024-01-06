-- run some additional configuration to make things how you want on boot
exec("loadengine default") -- can swap to whatever engine state you like
exec("overlay off Layers") -- run standard commands for toggling on/off certain features

-- I hate typing so I'm going to make a functions that prints something I want to see
-- I make these aliases pretty regularly for things I use often. even better 
function rt()
    print(real_time())
end

-- fload('default_loader')

-- if Controller.State.Prefix ~= "utest" then
--     if save_state_exists("utest") then
--         fload("utest")
--         push(1371)
--     end
-- end

-- function p()
--     c=require('cloning')
-- end

-- function f()
--     p()
--     local farm = c.LocationFromName("Farm")
--     interface:ScreenshotLocation(farm, "farm_utest")
--     return farm
-- end

-- function g()
--     for k,v in dict_items(DayUpdateRandom.Lookup) do
--         printf("%s: %s", k, v)
--     end
-- end

-- function real()
--     g()
--     interface:ScreenshotLocation(Game1.locations[0],"farm_real")
-- end