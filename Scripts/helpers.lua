cm = require('chair_move')
cr = require('clone_replay')
fish = require('fishing')
info = require('info')
co = require('combat')

function object_tiles(name)
    if name == nil then
        name = "Chest"
    end
    local objects = RunCS("Game1.currentLocation").Objects
    for k,v in dict_items(objects) do
        if v.Name == name then
            print(string.format("Chest at %d,%d", v.TileLocation.X, v.TileLocation.Y))
        end
    end
end

function furniture_tiles(name)
    if name == nil then
        name = "Oak Chair"
    end
    local furniture = RunCS("Game1.currentLocation").furniture
    for k,v in list_items(furniture) do
        if v.Name == name then
            print(string.format("Chair at %d,%d", v.TileLocation.X, v.TileLocation.Y))
        end
    end
end

function inventory()
    for i,v in list_items(RunCS("Game1.player.items")) do
        if v ~= nil then 
            printf("%d\t%s\t%d\t(%s)",i,v.Name,v.Stack,v.Quality)
        end
    end
end

function monsters()
    for i,c in list_items(RunCS("Game1.currentLocation").characters) do 
        printf("%d\t%s\t%s",i,c.Name,c.Health) 
    end
end

function wait() 
    local x = DateTime.Now.Second
    while x == DateTime.Now.Second do
        advance()
    end
end
