local game1 = require('game1')
local info = {}

function info.prod()
    function _print_items(loc)
        for k,v in dict_items(loc.Objects) do
            if (v.Name == "Mayonnaise Machine" 
                or v.Name == "Recycling Machine" 
                or v.Name == "Cheese Press"
                or v.Name == "Deconstructor"
                or v.Name == "Wood Chipper"
            ) then
                local item = ""
                if v.heldObject.Value ~= nil then
                    item = v.heldObject.Value.Name
                end
                printf("%s\t%s\t%s",v.Name,v.MinutesUntilReady,item)
            end
        end
    end
    local mines = RunCS('Game1.getLocationFromName("Mine")')
    local farm = RunCS('Game1.getLocationFromName("Farm")')
    _print_items(mines)
    _print_items(farm)
end

function info.chest()
    local farm = RunCS('Game1.getLocationFromName("Farm")')
    for k,v in dict_items(farm.Objects) do
        if v.Name == "Chest" then
            printf("%s\t(%s,%s)",v.Name,v.TileLocation.X, v.TileLocation.Y)
            local items = {}
            for i,v in list_items(v.items) do
                table.insert(items, string.format(
                    "%s (%s)", v.Name, v.Stack
                ))
            end
            print(items)
        end
    end
end

function info.buffs()
    local food = RunCS("Game1.buffsDisplay.food")
    local drink = RunCS("Game1.buffsDisplay.drink")
    if food ~= nil then
        printf('%s\t%d/\t%d',food.source, food.millisecondsDuration, food.totalMillisecondsDuration)
    end
    if drink ~= nil then
        printf('%s\t%d/\t%d',drink.source, drink.millisecondsDuration, drink.totalMillisecondsDuration)
    end
end

function info.crates()
    local object_dict = Controller.Overlays["ObjectDrop"].objectsThatHaveDrops
    for k,v in dict_items(object_dict) do
        local s = {}
        for i,n in list_items(v) do
            table.insert(s, n)
        end
        printf("(%s,%s) ->%s",k.X, k.Y, string.join(", ", s))
    end
end

function info.test(n)
    if n == nil then
        n = 30
    end
    local chance = RunCS("Game1.player.team.AverageDailyLuck(Game1.currentLocation) / 10.0 + Game1.player.team.AverageLuckLevel(Game1.currentLocation) / 100.0")+0.01
    local r = game1_random()
    local index = info.get_index(r)
    local vals = {}
    for i=0,n do
        local v = r:NextDouble()
        if v < chance then
            printf("%d\t%s", index+i,v, chance)
            table.insert(vals, index+i)
        end
    end
    return vals
end

function info.get_index(r)
    local s = string.split(string.split(tostring(r),'}')[1],":")[3]
    return tonumber(s)
end

function info.last()
    
    return {
        info.get_index(interface:GetLastMinesLoadLevelRNG()),
        info.get_index(interface:GetLastMinesTreasureRNG())
    }
end

function info.advance_rng(r,n)
    for i=1,n do
        r:NextDouble()
    end
    return r
end

function info.treasure(r)
    local v = r:Next(26)
    print(v)
    local t = {
        [0]=288,
        [1]=287,
        [2]=802,
        [3]=773,
        [4]=749,
        [5]=688,
        [6]=681,
        [7]=function(r)return r:Next(628,634)end,
        [8]=645,
        [9]=621,
        [10]=function(r)return r:Next(472,499)end,
        [11]=286,
        [12]=437,
        [13]=439,
        [14]=349,
        [15]=337,
        [16]=function(r)return r:Next(235,245)end,
        [17]=74,
        [18]=-1,
        [19]=-1,
        [20]=-1,
        [21]=-2,
        [22]=-2,
        [23]=-2,
        [24]=-1,
        [25]=-2
    }
    local item = t[v]
    print(item)
    if type(item) == "function" then
        local c = item(r)
        print(c)
        return game1.objectName(c)
    elseif item == -1 then
        return "hat"
    elseif item == -2 then
        return "object"
    else
        
        return game1.objectName(item)
    end
end

function info.cycle(n,skip)
    if n == nil then
        n = 77
    end
    if skip == nil then
        advance()
    end
    local r = game1_random()
    local ridx = info.get_index(r)
    local test = info.test(80)
    printf("%d\t%d\t%d",current_frame(), test[1], ridx)
    local last = info.last()
    if test[1] == ridx then
        print(info.treasure(info.advance_rng(r,n)))
    end
end

function info.tc()
    local objects = RunCS("Game1.currentLocation.Objects")
    if not objects:ContainsKey(Vector2(9,9)) then
        return nil
    end
    local item = objects[Vector2(9,9)].items[0]
    printf("%s\t%d",item.Name,item.Stack)
    return item
end

function info.brute()
    local r = game1_random()
    local ridx = info.get_index(r)
    local test = info.test(80)
    printf("%d\t%d\t%d",current_frame(), test[1], ridx)
    local last = info.last()
    if test[1] == ridx then
        print(info.treasure(info.advance_rng(r,77)))
    end
end

-- local sim = {
--     diff=0,
--     X
-- }
-- function sim.step()

function info.dio(fr, lookahead)
    local function solve(diff,fr)
        local y = 0
        local x = 0
        local toggle = true
        while diff > 0 do
            if diff % fr == 0 and (fr ~= 1 or diff < 2*fr + 4) then
                -- we can wait for the solution
                x = x + 1
                diff = diff - fr
                goto continue
            end
            if toggle then
                y = y + 1
                diff = diff - fr - 4
            else
                x = x + 1 
                diff = diff - fr
            end
            toggle = not toggle

            ::continue::
        end
        return {diff,x,y}
    end
    if fr == nil then
        fr = 5
    end
    if lookahead == nil then
        lookahead = 100
    end
    local C = info.get_index(game1_random())
    local Ns = info.test(lookahead)
    for i,N in ipairs(Ns) do
        local s = solve(N-C,fr)
        printf("%d,%d,wait:%d,swing:%d",N-C,s[1],s[2],s[3])
    end
end

function info.timer()
    return RunCS("Game1.currentLocation.Objects")[Vector2(9,9)].frameCounter
end

function info.totems(totem_id, n_scan)
    local function check_rng(r)
        r:NextDouble() -- qi beans
        r:NextDouble() -- guntherBones
        if r:NextDouble() < 0.1 then
            return 688 + r:Next(3)
        end
        return -1
    end
    if n_scan == nil then
        n_scan = 500
    end
    local curr = info.get_index(game1_random())
    printf('curr: %d',curr)
    local indices = {}
    for i=1,n_scan do
        local random = info.advance_rng(game1_random(),i)
        local index = info.get_index(random)
        local v = check_rng(random)
        if v ~= -1 then
            if totem_id == nil or totem_id == v then
                printf("%d\t%d\t%s", index, index-curr, game1.objectName(v))
                table.insert(indices, index-curr)
            end
        end
    end
    return indices
end

function info.slots(n)
    if n == nil then
        n = 100
    end
    local r = game1_random()
    local curr = info.get_index(r)
    local chance = 0.00547
    for i=0,n do
        local idx = info.get_index(r)
        local v = r:NextDouble()
        if v < chance then
            printf("%d\t%d\t%f\t%s", i, idx, v, idx-curr)
        end
    end
end

return info