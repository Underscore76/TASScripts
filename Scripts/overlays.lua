local timers = {}

function timers.clear()
    Controller.Overlays["TimerPanel"]:Clear()
    Controller.Overlays["TimerPanel"].CurrentFrame = 0
end

function timers.register(show_frame, start_frame, end_frame, always_show)
    if show_frame == nil then
        Controller.Overlays["TimerPanel"]:RegisterTimer(0)
    elseif start_frame == nil then
        Controller.Overlays["TimerPanel"]:RegisterTimer(show_frame)
    elseif end_frame == nil then
        Controller.Overlays["TimerPanel"]:RegisterTimer(show_frame, start_frame)
    elseif always_show == nil then
        Controller.Overlays["TimerPanel"]:RegisterTimer(show_frame, start_frame, end_frame)
    else
        Controller.Overlays["TimerPanel"]:RegisterTimer(show_frame, start_frame, end_frame, always_show)
    end
end

function timers.state(flag)
    if flag == nil then
        Controller.Overlays["TimerPanel"].DrawSaveState = not Controller.Overlays["TimerPanel"].DrawSaveState
    else
        Controller.Overlays["TimerPanel"].DrawSaveState = flag
    end
end

function timers.set_max(n)
    Controller.Overlays["TimerPanel"].MaxFrame = n
end

local text_panel = {}

function text_panel.clear()
    Controller.Overlays["TextPanel"].Text = ""
end

function text_panel.set(text)
    Controller.Overlays["TextPanel"].Text = text
end

function text_panel.get()
    return Controller.Overlays["TextPanel"].Text
end

local overlays = {
    timers = timers,
    text_panel = text_panel
}
return overlays