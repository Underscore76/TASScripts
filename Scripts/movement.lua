Queue = require("queue")

local movement = {}
movement.DIR = {
    UP=Vector2(0,-1),
    UPRIGHT=Vector2(0.7,-0.7),
    RIGHT=Vector2(1,0),
    DOWNRIGHT=Vector2(0.7,0.7),
    DOWN=Vector2(0,1),
    DOWNLEFT=Vector2(-0.7,0.7),
    LEFT=Vector2(-1,0),
    UPLEFT=Vector2(-0.7,-0.7)
}


function movement.ContainedRect(rect, tile)
    local x = rect.X
    local y = rect.Y
    local w = rect.Width
    local h = rect.Height
    local tx = tile.X * 64
    local ty = tile.Y * 64
    return x > tx and x+w < tx+64 and y > ty and y+h < ty+64
end

function movement.ContainedRectCentered(rect, tile)
    local x = rect.X
    local y = rect.Y
    local w = rect.Width
    local h = rect.Height
    local tx = tile.X * 64
    local ty = tile.Y * 64
    return x+4 > tx and x+w+12 < tx+64 and y-12 > ty and y+h+12 < ty+64
end

function movement.HalfHeight(vec, tile)
    local ttop = tile.Y * 64
    local tbottom = (tile.Y+1)*64 
    local vtop = vec.Y + 14
    local vbottom = vec.Y + 32 -14
    if vtop < ttop then
        return 1
    end
    if vbottom > tbottom then
        return -1
    end
    return 0
end

function movement.CenteredTileHeight(vec, tile)
    local ttop = tile.Y * 64
    local tbottom = (tile.Y+1)*64 
    local vtop = vec.Y - 12
    local vbottom = vec.Y + 32 + 12
    if vtop < ttop then
        return 1
    end
    if vbottom > tbottom then
        return -1
    end
    return 0
end

function movement.BottomSided(vec, tile)
    local ttop = tile.Y * 64
    local tbottom = (tile.Y+1)*64 
    local vtop = vec.Y - 24
    local vbottom = vec.Y + 32
    if vtop < ttop then
        return 1
    end
    if vbottom > tbottom then
        return -1
    end
    return 0
end
function movement.TopSided(vec, tile)
    local ttop = tile.Y * 64
    local tbottom = (tile.Y+1)*64 
    local vtop = vec.Y
    local vbottom = vec.Y + 32 + 24
    if vtop < ttop then
        return 1
    end
    if vbottom > tbottom then
        return -1
    end
    return 0
end

function movement.CenteredTileWidth(vec, tile)
    local tleft = tile.X * 64
    local tright = (tile.X+1)*64 
    local vleft = vec.X + 8 - 4
    local vright = vec.X + 48 + 8 + 4
    if vleft < tleft then
        return 1
    end
    if vright > tright then
        return -1
    end
    return 0
end

function movement.CompareTileHeight(vec, tile)
    local ttop = tile.Y * 64
    local tbottom = (tile.Y+1)*64 
    local vtop = vec.Y
    local vbottom = vec.Y + 32
    if vtop < ttop then
        return 1
    end
    if vbottom > tbottom then
        return -1
    end
    return 0
end

function movement.CompareTileWidth(vec, tile)
    -- |----| vl, vr
    --   |==============| tl, tr
    -- if vl < tl we are below the lower bound and need to go right
    -- if vr > tr we are above the upper bound and need to go left
    local tleft = tile.X * 64
    local tright = (tile.X+1)*64 
    local vleft = vec.X + 8
    local vright = vec.X + 48 + 8
    if vleft < tleft then
        return 1
    end
    if vright > tright then
        return -1
    end
    return 0
end

local function Step(vec, dir, speed)
    return vec + dir*speed
end

function movement.GetMouseTileFromGlobal(tileX, tileY)
    local tileSize = RunCS("Game1.tileSize")
    local viewport = RunCS("Game1.viewport")
    local zoomLevel = RunCS("Game1.options.zoomLevel")
    local tile = {X=(tileX+0.5)*tileSize, Y=(tileY+0.5)*tileSize}
    local localX = (tile.X - viewport.X) * zoomLevel
    local localY = (tile.Y - viewport.Y) * zoomLevel
    return {X=localX, Y=localY}
end

function movement.CollectNearby()
    local last_mouse = RunCS("Controller.LastFrameMouse()")
    local mouseTile = Vector2(last_mouse.MouseX, last_mouse.MouseY) * (1.0/Game1.options.zoomLevel)
    local mouseTileX = math.floor((mouseTile.X + Game1.viewport.X) / Game1.tileSize)
    local mouseTileY = math.floor((mouseTile.Y + Game1.viewport.Y) / Game1.tileSize)
    local loc = Game1.player:getTileLocation()
    local x = loc.X
    local y = loc.Y
    local radius = 1
    local mouse = {X=last_mouse.MouseX, Y=last_mouse.MouseY, left=false, right=false}
    -- attempt to click the current one
    for i = x-radius, x+radius do
        for j = y-radius, y+radius do
            local tile = Vector2(i,j)
            if Game1.currentLocation.Objects:ContainsKey(tile) then
                local obj = Game1.currentLocation.Objects[tile]
                if obj ~= nil then
                    if obj.heldObject.Value ~= nil and obj.readyForHarvest.Value then
                        -- printf("\tfound object: %s %d %d %s", obj.Name, obj.TileLocation.X, obj.TileLocation.Y, obj.heldObject.Value.Name)
                        -- printf("mouseTile %f,%f -> %f,%f (%s)", mouseTileX, mouseTileY, tile.X, tile.Y, mouseTileX == tile.X and mouseTileY == tile.Y)
                        if mouseTileX == tile.X and mouseTileY == tile.Y then
                            -- printf("\t\tfound mouse tile")
                            if last_mouse.LeftMouseClicked then
                                mouse.right = true
                            else
                                mouse.left = true
                            end
                            goto continue
                        else
                            local tile = movement.GetMouseTileFromGlobal(i,j)
                            mouse.X = tile.X
                            mouse.Y = tile.Y
                            goto continue
                        end
                        -- return {wait=false, mouse=mouse}
                    end
                end
            end
            ::continue::
        end
    end
    ::exit::
    return {override_keyboard=false, mouse=mouse, keyboard=nil}
end

local DropInObjects = {
    "Deconstructor",
    "Wood Chipper"
}
function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local InventoryKeys = {
    [0]={Keys.D1},
    [1]={Keys.D2},
    [2]={Keys.D3},
    [3]={Keys.D4},
    [4]={Keys.D5},
    [5]={Keys.D6},
    [6]={Keys.D7},
    [7]={Keys.D8},
    [8]={Keys.D9},
    [9]={Keys.D0},
    [10]={Keys.OemMinus},
    [11]={Keys.OemPlus},
    [12]={Keys.Tab},
    [13]={Keys.Tab},
    [14]={Keys.Tab},
    [15]={Keys.Tab},
    [16]={Keys.Tab},
    [17]={Keys.Tab},
    [18]={Keys.Tab},
    [19]={Keys.Tab},
    [20]={Keys.Tab},
    [21]={Keys.Tab},
    [22]={Keys.Tab},
    [23]={Keys.Tab},
    [24]={Keys.Tab},
    [25]={Keys.Tab},
    [26]={Keys.Tab},
    [27]={Keys.Tab},
    [28]={Keys.Tab},
    [29]={Keys.Tab},
    [30]={Keys.Tab},
    [31]={Keys.Tab},
    [32]={Keys.Tab},
    [33]={Keys.Tab},
    [34]={Keys.Tab},
    [35]={Keys.Tab},
}

function movement.GetInventoryKey(name, minStack)
    if minStack == nil then
        minStack = 1
    end
    if Game1.player.CurrentItem ~= nil and Game1.player.CurrentItem.Name == name then
        return {}
    end
    for i = 0, Game1.player.MaxItems-1 do
        if Game1.player.Items[i] ~= nil and Game1.player.Items[i].Name == name then
            if Game1.player.Items[i].Stack >= minStack then
                return InventoryKeys[i]
            end
        end
    end
    return nil
end

function movement.CollectThenDrop(name)
    return function ()
        local last_mouse = RunCS("Controller.LastFrameMouse()")
        local mouseTile = Vector2(last_mouse.MouseX, last_mouse.MouseY) * (1.0/Game1.options.zoomLevel)
        local mouseTileX = math.floor((mouseTile.X + Game1.viewport.X) / Game1.tileSize)
        local mouseTileY = math.floor((mouseTile.Y + Game1.viewport.Y) / Game1.tileSize)
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        local mouse = {X=last_mouse.MouseX, Y=last_mouse.MouseY, left=false, right=false}
        local keyboard = movement.GetInventoryKey(name)
        -- attempt to click the current one
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    local obj = Game1.currentLocation.Objects[tile]
                    if not table.contains(DropInObjects, obj.Name) then
                        goto continue
                    end
                    if obj ~= nil then
                        if obj.heldObject.Value ~= nil and obj.readyForHarvest.Value then
                            -- printf("\tfound object: %s %d %d %s", obj.Name, obj.TileLocation.X, obj.TileLocation.Y, obj.heldObject.Value.Name)
                            -- printf("mouseTile %f,%f -> %f,%f (%s)", mouseTileX, mouseTileY, tile.X, tile.Y, mouseTileX == tile.X and mouseTileY == tile.Y)
                            if mouseTileX == tile.X and mouseTileY == tile.Y then
                                -- printf("\t\tfound mouse tile")
                                if last_mouse.LeftMouseClicked then
                                    mouse.right = true
                                else
                                    mouse.left = true
                                end
                                goto continue
                            else
                                local tile = movement.GetMouseTileFromGlobal(i,j)
                                mouse.X = tile.X
                                mouse.Y = tile.Y
                                goto continue
                            end
                            -- return {wait=false, mouse=mouse}
                        elseif obj.heldObject.Value == nil then
                            if mouseTileX == tile.X and mouseTileY == tile.Y then
                                -- printf("\t\tfound mouse tile")
                                if last_mouse.LeftMouseClicked then
                                    mouse.right = true
                                else
                                    mouse.left = true
                                end
                                goto continue
                            else
                                local tile = movement.GetMouseTileFromGlobal(i,j)
                                mouse.X = tile.X
                                mouse.Y = tile.Y
                                goto continue
                            end
                        end
                    end
                end
                ::continue::
            end
        end
        ::exit::
        return {override_keyboard=false, mouse=mouse, keyboard=keyboard}
    end
end

function movement.Harvest()
    return function ()
        local last_mouse = RunCS("Controller.LastFrameMouse()")
        local mouseTile = Vector2(last_mouse.MouseX, last_mouse.MouseY) * (1.0/Game1.options.zoomLevel)
        local mouseTileX = math.floor((mouseTile.X + Game1.viewport.X) / Game1.tileSize)
        local mouseTileY = math.floor((mouseTile.Y + Game1.viewport.Y) / Game1.tileSize)
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        local mouse = {X=last_mouse.MouseX, Y=last_mouse.MouseY, left=false, right=false}
        local keyboard = {}
        
        -- attempt to click the current one
        local count = 0
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    local obj = Game1.currentLocation.Objects[tile]
                    if obj ~= nil and obj.IsSpawnedObject then
                        count = count + 1
                        if mouseTileX == tile.X and mouseTileY == tile.Y then
                            -- printf("\t\tfound mouse tile")
                            if last_mouse.RightMouseClicked then
                                table.insert(keyboard, Keys.X)
                            else
                                mouse.right = true
                            end
                            goto continue
                        else
                            local tile = movement.GetMouseTileFromGlobal(i,j)
                            mouse.X = tile.X
                            mouse.Y = tile.Y
                            goto continue
                        end
                    end
                end
                ::continue::
            end
        end
        ::exit::
        if count == 0 and not Game1.player.CanMove then
            advance({keyboard={Keys.C}})
            advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
            -- return {override_keyboard=true, mouse=mouse, keyboard=keyboard}
        end
        if count > 0 then
            movement.SwapToItem("Infinity Blade")
        end
        return {override_keyboard=false, mouse=mouse, keyboard=keyboard, use=count>0}
    end
end

function movement.Plant(seedName)
    return function () 
        local last_mouse = RunCS("Controller.LastFrameMouse()")
        local mouseTile = Vector2(last_mouse.MouseX, last_mouse.MouseY) * (1.0/Game1.options.zoomLevel)
        local mouseTileX = math.floor((mouseTile.X + Game1.viewport.X) / Game1.tileSize)
        local mouseTileY = math.floor((mouseTile.Y + Game1.viewport.Y) / Game1.tileSize)
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        local mouse = {X=last_mouse.MouseX, Y=last_mouse.MouseY, left=false, right=false}
        local keyboard = {}
        local count = 0
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                if Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    local tf = Game1.currentLocation.terrainFeatures[tile]
                    if not Game1.currentLocation.Objects:ContainsKey(tile) then
                        if tf:GetType().Name == "HoeDirt" and tf.crop == nil then
                            count = count + 1
                            if mouseTileX == tile.X and mouseTileY == tile.Y then
                                -- printf("\t\tfound mouse tile")
                                if last_mouse.RightMouseClicked then
                                    table.insert(keyboard, Keys.X)
                                else
                                    mouse.right = true
                                end
                                goto continue
                            else
                                local tile = movement.GetMouseTileFromGlobal(i,j)
                                mouse.X = tile.X
                                mouse.Y = tile.Y
                                goto continue
                            end
                        end
                    end
                end
                ::continue::
            end
        end
        if count > 0 then
            movement.SwapToItem(seedName)
        end
        return {override_keyboard=false, mouse=mouse, keyboard=keyboard, use=count>0}
    end
end

function movement.Sword()
    return function ()
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        local tiles = {}
        local count = 0
        for i = -radius, radius do
            for j = -radius, radius do
                local tile = Vector2(x+i,y+j)
                if Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    local tf = Game1.currentLocation.terrainFeatures[tile]
                    if tf:GetType().Name == "Grass" then
                        count = count + 1
                        if i < 0 and j < 0 then
                            tiles.topLeft = true
                        elseif i < 0 and j == 0 then
                            tiles.left = true
                        elseif i < 0 and j > 0 then
                            tiles.bottomLeft = true
                        elseif i == 0 and j < 0 then
                            tiles.top = true
                        elseif i == 0 and j == 0 then
                            tiles.center = true
                        elseif i == 0 and j > 0 then
                            tiles.bottom = true
                        elseif i > 0 and j < 0 then
                            tiles.topRight = true
                        elseif i > 0 and j == 0 then
                            tiles.right = true
                        elseif i > 0 and j > 0 then
                            tiles.bottomRight = true
                        end
                    end
                end
            end
        end
        if count == 0 then
            return nil
        end
        -- tile up right has grass
        movement.SwapToItem("Infinity Blade")
        if tiles.right then
            local mouse = movement.GetMouseTileFromGlobal(loc.X,loc.Y+1)
            for i=1,2 do
                mouse.left=false
                advance({mouse=mouse})
                mouse.left=true
                advance({mouse=mouse})
                advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
            end
            movement.WalkToTile(loc)
        elseif tiles.bottomRight then
            local mouse = movement.GetMouseTileFromGlobal(loc.X,loc.Y+2)
            movement.WalkCardinal(movement.DIR.DOWN)
            for i=1,2 do
                mouse.left=false
                advance({mouse=mouse})
                mouse.left=true
                advance({mouse=mouse})
                advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
            end
            movement.WalkToTile(loc)
        elseif tiles.bottomLeft or tiles.bottom then
            local mouse = movement.GetMouseTileFromGlobal(loc.X,loc.Y+1)
            for i=1,2 do
                mouse.left=false
                advance({mouse=mouse})
                mouse.left=true
                for j=1,12 do
                    advance({mouse=mouse})
                end
                advance({mouse=mouse})
                advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
            end
            movement.WalkToTile(loc)
        end
    end
end

function movement.Hoe()
    local hasBuildings = Game1.currentLocation.buildings ~= nil
    return function () 
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        -- use the hoe
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                -- there's an object here already
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    goto continue
                end
                -- there is already a terrain feature here
                if Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    goto continue
                end
                -- this overlaps with a building
                if hasBuildings then
                    for i, b in list_items(Game1.currentLocation.buildings) do
                        if b:occupiesTile(tile) then
                            goto continue
                        end
                    end
                end
                if Game1.currentLocation:doesTileHaveProperty(tile.X, tile.Y, "Diggable", "Back") then
                    movement.UseToolOnTile("Hoe", tile)
                end
                ::continue::
            end
        end
        return nil
    end
end

function movement.Water()
    return function () 
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        -- use the hoe
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                -- there's an object here already
                if not Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    goto continue
                end
                local tf = Game1.currentLocation.terrainFeatures[tile]
                if tf:GetType().Name ~= "HoeDirt" then
                    goto continue
                end
                if tf.state.Value == 0 then
                    movement.UseToolOnTile("Watering Can", tile)
                end
                ::continue::
            end
        end
        return nil
    end
end

function movement.Pickaxe()
    return function ()
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        -- use the hoe
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                -- there's an object here already
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    local obj = Game1.currentLocation.Objects[tile]
                    if obj.Name == "Stone" then
                        movement.UseToolOnTile("Iridium Pickaxe", tile)
                    end
                    goto continue
                end
                if Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    local tf = Game1.currentLocation.terrainFeatures[tile]
                    if tf:GetType().Name == "HoeDirt" then
                        if tf.crop ~= nil and tf.crop.dead.Value then
                            movement.UseToolOnTile("Iridium Pickaxe", tile)
                        end
                    end
                    goto continue
                end
                ::continue::
            end
        end
        return nil
    end
end

function movement.Axe()
    return function ()
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        -- use the hoe
        for i = x-radius, x+radius do
            for j = y-radius, y+radius do
                local tile = Vector2(i,j)
                -- there's an object here already
                if Game1.currentLocation.Objects:ContainsKey(tile) then
                    local obj = Game1.currentLocation.Objects[tile]
                    if obj.Name == "Axe" then
                        movement.UseToolOnTile("Iridium Axe", tile)
                    end
                    goto continue
                end
                ::continue::
            end
        end
        return nil
    end
end

function movement.Scythe()
    return function () 
        local loc = Game1.player:getTileLocation()
        local x = loc.X
        local y = loc.Y
        local radius = 1
        local block_swings = {
            left=0,
            right=0,
            down=0,
            up=0
        }
        -- use the hoe
        for i = -radius,radius do
            for j = -radius,radius do
                local tile = Vector2(x+i,y+j)
                -- if math.abs(i) + math.abs(j) > radius then
                --     goto continue
                -- end
                -- there's an object here already
                if not Game1.currentLocation.terrainFeatures:ContainsKey(tile) then
                    goto continue
                end
                local tf = Game1.currentLocation.terrainFeatures[tile]
                if tf:GetType().Name ~= "HoeDirt" then
                    goto continue
                end
                if tf.crop ~= nil and tf.crop.dead.Value then
                    if j >= 0 then
                        block_swings.down = block_swings.down + 1
                    end
                    if i >= 0 then
                        block_swings.right = block_swings.right + 1
                    end
                    if i <= 0 then
                        block_swings.left = block_swings.left + 1
                    end
                end
                ::continue::
            end
        end
        local maxDir = "down"
        local max = block_swings.down
        for k,v in pairs(block_swings) do
            if v > max then
                max = v
                maxDir = k
            end
        end
        if max <= 0 then
            return nil
        end
        movement.SwapToItem("Golden Scythe")
        local mouse
        local frames = 1
        if maxDir == "left" then
            mouse = movement.GetMouseTileFromGlobal(loc.X-1,loc.Y)
            frames = 1
        elseif maxDir == "right" then
            mouse = movement.GetMouseTileFromGlobal(loc.X,loc.Y+1)
            frames = 1
        elseif maxDir == "down" then
            mouse = movement.GetMouseTileFromGlobal(loc.X,loc.Y+1)
            frames = 1
        elseif maxDir == "up" then
            mouse = movement.GetMouseTileFromGlobal(loc.X-1,loc.Y)
            frames = 1            
        end
        advance({mouse=mouse})
        mouse.left=true
        advance({mouse=mouse})
        for i=1,frames do
            advance()
        end
        advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
        return nil
    end
end

function movement.HaveItems(item, minStackSize)
    local inv = movement.GetInventoryKey(item, minStackSize)
    return inv ~= nil
end

function movement.SwapToItem(itemName)
    if not movement.HaveItems(itemName) then
        error("Could not find item: " .. itemName)
    end
    while Game1.player.CurrentItem == nil or Game1.player.CurrentItem.Name ~= itemName do
        local keys = movement.GetInventoryKey(itemName)
        advance({keyboard=keys})
        advance()
    end
end

function movement.AdvanceUntilLocationChange(key, mouse, toggle)
    local name = Game1.currentLocation.Name
    if key ~= nil and type(key) ~= "table" then
        key = {key}
    end
    if toggle ~= nil then
        toggle = true
    else 
        toggle = false
    end
    while Game1.currentLocation.Name == name do
        advance({keyboard=key, mouse=mouse})
        if toggle then
            advance({mouse={X=mouse.X, Y=mouse.Y, left=false, right=false}})
        end
    end
    halt()
end

function movement.AdvanceUntilMenu(key, mouse, toggle)
    if key ~= nil and type(key) ~= "table" then
        key = {key}
    end
    if toggle ~= nil then
        toggle = true
    else 
        toggle = false
    end
    while Game1.activeClickableMenu == nil do
        advance({keyboard=key, mouse=mouse})
        if toggle then
            advance()
        end
    end
    halt()
end

function movement.AdvanceUntilExitMenu(key, mouse, toggle)
    if key ~= nil and type(key) ~= "table" then
        key = {key}
    end
    if toggle ~= nil then
        toggle = true
    else 
        toggle = false
    end
    while Game1.activeClickableMenu ~= nil do
        advance({keyboard=key, mouse=mouse})
        if toggle then
            advance()
        end
    end
    halt()
end

function movement.AdvanceUntilMinigame(key, mouse, toggle)
    if key ~= nil and type(key) ~= "table" then
        key = {key}
    end
    if toggle ~= nil then
        toggle = true
    else 
        toggle = false
    end
    while Game1.currentMinigame == nil do
        advance({keyboard=key, mouse=mouse})
        if toggle then
            advance()
        end
    end
    halt()
end

function movement.UseToolOnTile(toolName, tile)
    local p = Game1.player:getTileLocation()
    for x=-1,1 do
        for y=-1,1 do
            local t = Vector2(p.X+x,p.Y+y)
            if t.X == tile.X and t.Y == tile.Y then
                movement.SwapToItem(toolName)
                local mouse = movement.GetMouseTileFromGlobal(tile.X,tile.Y)
                advance({mouse=mouse})
                mouse = {X=mouse.X, Y=mouse.Y, left=true}
                advance({mouse=mouse})
                advance({keyboard={Keys.RightShift, Keys.R, Keys.Delete}})
                return
            end
        end
    end
end

function movement.WalkCardinal(dir, frame_func, tfunc)
    local loc = Game1.player:getTileLocation()
    local moveTile = loc + dir
    local c = 0
    if tfunc == nil then
        if dir == movement.DIR.DOWN or dir == movement.DIR.UP then
            tfunc = movement.CompareTileHeight
        else
            tfunc = movement.CompareTileWidth
        end
    end
    local s = tfunc(Game1.player.position, moveTile)
    while s ~= 0 do
        local keyboard = {}
        if dir == movement.DIR.DOWN then
            table.insert(keyboard, Keys.S)
        elseif dir == movement.DIR.UP then
            table.insert(keyboard, Keys.W)
        elseif dir == movement.DIR.LEFT then
            table.insert(keyboard, Keys.A)
        elseif dir == movement.DIR.RIGHT then
            table.insert(keyboard, Keys.D)
        end
        if frame_func then
            local res = frame_func()
            if res.kill then
                return
            end
            if res.keyboard ~= nil then
                if res.override_keyboard then
                    keyboard = res.keyboard
                else
                    for _,v in ipairs(res.keyboard) do
                        table.insert(keyboard, v)
                    end
                end
            end
            advance({keyboard=keyboard, mouse=res.mouse})
        else
            advance({keyboard=keyboard})
        end
        c = c + 1
        if c > 100 then
            error("failed to walk cardinal")
        end
        s = tfunc(Game1.player.position, moveTile)
    end
end

function movement.WalkToTile(tile, frame_func, centered)
    if centered == nil then
        centered = false
    end
    -- printf("walking to tile %d,%d", tile.X, tile.Y)
    Controller.pathFinder:Reset()
    Controller.pathFinder:Update(tile.X, tile.Y, false)
    local counter = 0
    local xfunc = movement.CompareTileWidth
    local yfunc = movement.CompareTileHeight
    local cfunc = movement.ContainedRect
    if centered then
        xfunc = movement.CenteredTileWidth
        yfunc = movement.CenteredTileHeight
        cfunc = movement.ContainedRectCentered
    end
    while Controller.pathFinder.path.Count > 0 do
        -- print("walking")
        counter = counter + 1
        if counter > 5000 then
            printf("failed to walk to tile %d,%d", tile.X, tile.Y)
            return counter
        end
        local loc = Controller.pathFinder:PeekFront()
        local next = nil
        if Controller.pathFinder.path.Count > 1 then
            next = Controller.pathFinder.path[1]
        end
        if loc == nil then
            break
        end
        local moveTile = loc:toVector2()
        if cfunc(Game1.player:GetBoundingBox(), moveTile) then
            Controller.pathFinder:PopFront()
            goto continue
        end
        
        local speed = Game1.player:getMovementSpeed()
        local keyboard = {}
        local xdir = xfunc(Game1.player.Position, moveTile)
        if xdir > 0 then
            table.insert(keyboard, Keys.D)
        elseif xdir < 0 then
            table.insert(keyboard, Keys.A)
        end

        local ydir = yfunc(Game1.player.Position, moveTile)
        if ydir > 0 then
            table.insert(keyboard, Keys.S)
        elseif ydir < 0 then
            table.insert(keyboard, Keys.W)
        elseif next ~= nil then
            local nydir = yfunc(Game1.player.Position, next:toVector2())
            if xdir > 0 then
                if nydir > 0 then
                    local p = Step(Game1.player.Position, movement.DIR.DOWNRIGHT, speed)
                    if yfunc(p, moveTile) == 0 then
                        table.insert(keyboard, Keys.S)
                    end
                elseif nydir < 0 then
                    local p = Step(Game1.player.Position, movement.DIR.UPRIGHT, speed)
                    if yfunc(p, moveTile) == 0 then
                        table.insert(keyboard, Keys.W)
                    end
                end
            elseif xdir < 0 then
                if nydir > 0 then
                    local p = Step(Game1.player.Position, movement.DIR.DOWNLEFT, speed)
                    if yfunc(p, moveTile) == 0 then
                        table.insert(keyboard, Keys.S)
                    end
                elseif nydir < 0 then
                    local p = Step(Game1.player.Position, movement.DIR.UPLEFT, speed)
                    if yfunc(p, moveTile) == 0 then
                        table.insert(keyboard, Keys.W)
                    end
                end
            end
        end
        if xdir == 0 and ydir == 0 then
            Controller.pathFinder:PopFront()
            goto continue
        end
        if frame_func then
            local res = frame_func()
            if res.kill then
                return
            end
            if res.keyboard ~= nil then
                if res.override_keyboard then
                    keyboard = res.keyboard
                else
                    for _,v in ipairs(res.keyboard) do
                        table.insert(keyboard, v)
                    end
                end
            end
            advance({keyboard=keyboard, mouse=res.mouse})
        else
            advance({keyboard=keyboard})
        end
        halt()
        ::continue::
    end
    return counter
end

function movement.GetChestMouse(name, minStack)
    if minStack == nil then
        minStack = 1
    end
    for i,v in list_items(Game1.activeClickableMenu.ItemsToGrabMenu.actualInventory) do
        if v == nil then
            goto continue
        end
        if v.Name == name and v.Stack >= minStack then
            local center = Game1.activeClickableMenu.ItemsToGrabMenu.inventory[i].bounds.Center
            local mouse = {X=center.X, Y=center.Y, left=true}
            return mouse, Game1.activeClickableMenu.ItemsToGrabMenu.actualInventory[i]
        end
        ::continue::
    end
    return nil, nil
end

function movement.OpenChest(tileX, tileY)
    local last_mouse = RunCS("Controller.LastFrameMouse()")
    local mouse = movement.GetMouseTileFromGlobal(tileX,tileY)
    if last_mouse.MouseX ~= mouse.X or last_mouse.MouseY ~= mouse.Y then
        advance({mouse=mouse})
    end
    mouse.right = true
    movement.AdvanceUntilMenu(nil, mouse, true)
end

function movement.GetChestInventoryMouse(name, maxStack, minStack)
    for i,v in list_items(Game1.activeClickableMenu.inventory.actualInventory) do
        if v ~= nil and v.Name == name then
            if (maxStack == nil or v.Stack <= maxStack) and (minStack == nil or v.Stack >= minStack) then
                local center = Game1.activeClickableMenu.inventory.inventory[i].bounds.Center
                local mouse = {X=center.X, Y=center.Y, left=true}
                return mouse, Game1.activeClickableMenu.inventory.actualInventory[i]
            end
        end
    end
    return nil, nil
end

function movement.GetEmptyCraftingSlotMouse(submenu)
    for i,v in list_items(submenu.inventory.actualInventory) do
        if v == nil then
            local center = submenu.inventory.inventory[i].bounds.Center
            local mouse = {X=center.X, Y=center.Y, left=true}
            return mouse
        end
    end
    return nil
end

function movement.GetEmptyInventorySlots()
    local slots = {}
    for i,v in list_items(Game1.player.Items) do
        if v == nil then
            table.insert(slots, i)
        end
    end
    return #slots
end

function movement.GetInventoryMouse(name, maxStack)
    local submenu = Game1.activeClickableMenu.pages[0]
    for i,v in list_items(submenu.inventory.actualInventory) do
        if v ~= nil and v.Name == name then
            if maxStack == nil or v.Stack <= maxStack then
                local center = submenu.inventory.inventory[i].bounds.Center
                local mouse = {X=center.X, Y=center.Y, left=true}
                return mouse
            end
        end
    end
    return nil
end

return movement