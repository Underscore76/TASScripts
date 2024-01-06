local keybinds = require("core.keybinds")

local chair_move = {
    chair_name="Oak Chair"
}

local function player_get_tile_location()
    return RunCS("Game1.player.getTileLocation()")
end

local function _GetMouseTileRelativeToPlayer(tileX, tileY)
    local tileSize = RunCS("Game1.tileSize")
    local viewport = RunCS("Game1.viewport")
    local zoomLevel = RunCS("Game1.options.zoomLevel")
    local player = player_get_tile_location() * 64
    local offsetX = where(tileX <= 0, tileX + 0.5, tileX + 0.2)
    local offsetY = where(tileY <= 0, tileY + 0.5, tileY + 0.2)
    local localX = (player.X - viewport.X + tileSize * offsetX) * zoomLevel
    local localY = (player.Y - viewport.Y + tileSize * offsetY) * zoomLevel
    return {X=localX, Y=localY}
end

local function _GetMouseTileFromGlobal(tileX, tileY)
    local tileSize = RunCS("Game1.tileSize")
    local viewport = RunCS("Game1.viewport")
    local zoomLevel = RunCS("Game1.options.zoomLevel")
    local tile = {X=(tileX+0.5)*tileSize, Y=(tileY+0.5)*tileSize}
    local localX = (tile.X - viewport.X) * zoomLevel
    local localY = (tile.Y - viewport.Y) * zoomLevel
    return {X=localX, Y=localY}
end

function chair_move.find_chair()
    local furniture = RunCS("Game1.currentLocation").furniture
    for i,f in list_items(furniture) do
        if f.name == chair_move.chair_name then
            return f
        end
    end
end

local function mouse_up(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(0,-1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_down(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(0,1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function while_cant_move(mouse_func, key_func)
    local c = 0
    while RunCS("Game1.player").CanMove == false do
        local input = {}
        if key_func then
            input.keyboard = key_func()
        end
        if mouse_func then
            input.mouse = mouse_func()
        end
        advance(input)
        c = c + 1
        if c > 100 then
            break
        end
    end
end

local function mouse_right(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(1,0)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_left(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(-1,0)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_down_left(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(-1,1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_down_right(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(1,1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_up_left(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(-1,-1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function mouse_up_right(left,right)
    local mouse = _GetMouseTileRelativeToPlayer(1,-1)
    if left then
        mouse.left = left
    end
    if right then 
        mouse.right = right
    end
    return mouse
end

local function _prefix()
    exec("saveengine tmp")
    for i,v in dict_items(Controller.Logics) do
        if v.Toggleable then
            v.Active = false
        end
    end
end
local function _postfix()
    exec("loadengine tmp")
end

local function _mouse_func()
    local f = chair_move.find_chair().TileLocation
    local mouse = _GetMouseTileFromGlobal(f.X, f.Y)
    return mouse
end

local function diag_move(key, mouse_func)
    _prefix()
    advance({keyboard={key, Keys.X}, mouse=_mouse_func()})
    while_cant_move(_mouse_func, function() return {key} end)
    advance({keyboard={key, Keys.C}, mouse=_mouse_func()})
    advance({keyboard={key}, mouse=mouse_func()})
    advance({keyboard={key, Keys.C}, mouse=mouse_func()})
    advance({keyboard={Keys.X}, mouse=mouse_func()})
    _postfix()
end

function chair_move.lu()
    diag_move(Keys.A, mouse_up_left)
end
function chair_move.ru()
    diag_move(Keys.D, mouse_up_right)
end
function chair_move.ul()
    diag_move(Keys.W, mouse_up_left)
end
function chair_move.ur()
    diag_move(Keys.W, mouse_up_right)
end

function chair_move.rd()
    diag_move(Keys.D, mouse_down_right)
end
function chair_move.ld()
    diag_move(Keys.S, mouse_down_left)
end

function chair_move.dl()
    diag_move(Keys.S, mouse_down_left)
end

function chair_move.dr()
    diag_move(Keys.S, mouse_down_right)
end


keybinds.clear()
keybinds.add(Keys.I,
    function() 
        _prefix()
        advance({keyboard={Keys.X, Keys.W}, mouse=mouse_down()})
        while_cant_move(mouse_down)
        advance({keyboard={Keys.C}, mouse=mouse_up()})
        advance({mouse_up()})
        advance({keyboard={Keys.C}, mouse=mouse_up()})
        advance({keyboard={Keys.X}, mouse=mouse_up()})
        _postfix()
    end
)

keybinds.add(Keys.K,
    function() 
        _prefix()
        advance({keyboard={Keys.X, Keys.D}, mouse=mouse_up()})
        while_cant_move(mouse_up)
        advance({keyboard={Keys.C}, mouse=mouse_down()})
        advance({mouse_down()})
        advance({keyboard={Keys.C}, mouse=mouse_down()})
        advance({keyboard={Keys.X}, mouse=mouse_down()})
        _postfix()
    end
)

keybinds.add(Keys.J,
    function() 
        _prefix()
        advance({keyboard={Keys.X, Keys.A}, mouse=mouse_right()})
        while_cant_move(mouse_right)
        advance({keyboard={Keys.C}, mouse=mouse_left()})
        advance({mouse_left()})
        advance({keyboard={Keys.C}, mouse=mouse_left()})
        advance({keyboard={Keys.X}, mouse=mouse_left()})
        _postfix()
    end
)

keybinds.add(Keys.L,
    function()
        _prefix()
        advance({keyboard={Keys.X, Keys.D}, mouse=mouse_left()})
        while_cant_move(mouse_left)
        advance({keyboard={Keys.C}, mouse=mouse_right()})
        advance({mouse_right()})
        advance({keyboard={Keys.C}, mouse=mouse_right()})
        advance({keyboard={Keys.X}, mouse=mouse_right()})
        _postfix()
    end
)

keybinds.add(Keys.P, 
    function()
        if Controller.Logics['AdvanceFrozen'].Active then
            Controller.Logics['AdvanceFrozen'].Active = false
        else
            Controller.Logics['AdvanceFrozen'].Active = true
        end
    end
)

keybinds.add(Keys.O, 
    function()
        while RunCS("Game1.activeClickableMenu").safetyTimer > 0 do
            advance()
        end
    end
)

keybinds.add(Keys.N,
    function()
        iload("cord_museum")
    end
)

return chair_move