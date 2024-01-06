local engine = require('core.engine')

local wc = {}
function wc.run(n_trials)
    function _item()
        return RunCS("Game1.currentLocation.Objects[new Vector2(42,14)]").heldObject.Value.Name
    end
    if n_trials == nil then
        n_trials = 100
    end
    for i=1,n_trials do
        local f = current_frame()
        advance({keyboard={Keys.X}})
        local item = _item()
        if item == "Oak Resin" then
            print('success')
            return
        else
            printf("%d: %s", f, item)
        end
        engine.blocking_fast_reset(f)
        advance()
    end
    print("couldnt find oak resin")
end

return wc