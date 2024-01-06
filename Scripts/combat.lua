local combat = {}
local engine = require("core.engine")

function combat.find(item)
end

function combat.monsters()
    for i,c in list_items(RunCS("Game1.currentLocation").characters) do
        local s = ""
        for k,v in list_items(c.objectsToDrop) do
            if s == "" then
                s = v
            else
                s = s .. "," .. v
            end
        end
        printf("%d\t%s\t%s\t%s",i,c.Name,c.Health,s)
    end
end

function combat.fight(num_steps)
    local function _get_debris()
        local debris = RunCS("Game1.currentLocation.debris")
        local items = {}
        for i,v in list_items(debris) do
            if v.item ~= nil then
                table.insert(items, v.item.Name)
            end
        end
        return items
    end
    if num_steps == nil then
        num_steps = 10
    end
    local items = _get_debris()
    local f = current_frame()
    printf('start %d %s', f, string.join(",",items))
    for i=1,num_steps do
        f = current_frame()
        advance({keyboard={Keys.C}})
        items = _get_debris()
        if indexof(items, "Dinosaur Egg") then
            print("found egg")
            return
        end
        printf('failed %d %s', f, string.join(",",items))
        engine.blocking_fast_reset(f)
        advance()
    end
end

return combat