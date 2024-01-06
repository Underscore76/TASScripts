local function state(data)
    local s = {
        keyboard={},
        mouse={}
    }
    for i,key in list_items(data.keyboardState) do
        table.insert(s.keyboard, key)
    end
    s.mouse.X = data.mouseState.MouseX
    s.mouse.Y = data.mouseState.MouseY
    s.mouse.left = data.mouseState.LeftMouseClicked
    s.mouse.right = data.mouseState.RightMouseClicked

    function s.run()
        advance(s)
    end
    return s
end


local cr = {
    frames={},
    commands={},
    to_state=state
}

function cr.save()
    cr.frames = {}
    for i, fs in list_items(Controller.State.FrameStates) do
        local s = cr.to_state(fs)
        table.insert(cr.frames, s)
    end
end

function cr.apply(f_start)
    exec("saveengine tmp")
    exec("logic off all")
    for i, v in ipairs(cr.frames) do
        if i >= f_start then
            v.run()
        end
    end
    exec("loadengine tmp")
end

function cr.stash(name, f_start, f_end)
    cr.commands[name] = {}
    for i, v in ipairs(cr.frames) do
        if i >= f_start and i <= f_end then
            table.insert(cr.commands[name], v)
        end
    end
end

function cr.run(name)
    exec("saveengine tmp")
    exec("logic off all")
    for i, v in ipairs(cr.commands[name]) do
        v.run()
    end
    exec("loadengine tmp")
end

return cr