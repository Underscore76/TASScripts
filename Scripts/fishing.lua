local engine = require('core.engine')
local game1 = require('game1')
local fishing = {
    stop=false
}

function fishing.get_rod()
    local rod = RunCS("Game1.player").CurrentTool
    if (rod ~= nil) and (rod:GetType().Name == "FishingRod") then
        return {
            isTimingCast=rod.isTimingCast,
            isCasting=rod.isCasting,
            castedButBobberStillInAir=rod.castedButBobberStillInAir,
            fishingNibbleAccumulator=rod.fishingNibbleAccumulator,
            timeUntilFishingNibbleDone=rod.timeUntilFishingNibbleDone,
            timeUntilFishingBite=rod.timeUntilFishingBite,
            isFishing=rod.isFishing,
            isNibbling=rod.isNibbling,
            hit=rod.hit,
            fishCaught=rod.fishCaught,
        }
    else
        return {
            isTimingCast=false,
            isCasting=false,
            castedButBobberStillInAir=false,
            timeUntilFishingBite=nil,
            isFishing=false,
            isNibbling=false,
            hit=false,
            fishCaught=false,
        }
    end
end

function fishing.min_cast(dir_key)
    -- 43 frames left/right
    -- 62 up
    if dir_key ~= nil and type(dir_key) ~= "table" then
        dir_key = {dir_key}
    end
    advance({keyboard={Keys.C}})
    local x = 1
    while (fishing.get_rod().isTimingCast
        or fishing.get_rod().isCasting 
        or fishing.get_rod().castedButBobberStillInAir
    ) do
        if dir_key ~= nil then
            advance({keyboard=dir_key})
        else
            advance()
        end
        x = x + 1
    end
    return x
end

function fishing.delay_cast(n_frames, dir_key)
    -- 43 frames left/right
    -- 62 up
    -- if dir_key ~= nil and type(dir_key) ~= "table" then
    --     dir_key = {dir_key}
    -- end
    advance({keyboard={Keys.C}})
    local x = 1
    local keys = {}
    while (fishing.get_rod().isTimingCast
        or fishing.get_rod().isCasting 
        or fishing.get_rod().castedButBobberStillInAir
    ) do
        -- if then than n_frames have passed, hold the c button
        if x < n_frames then
            keys = {Keys.C}
        else
            keys = {}
        end
        if dir_key ~= nil then
            table.insert(keys, dir_key)
        end
        advance({keyboard=keys})
        x = x + 1
    end
    return x
end

function fishing.manip_nibble(max_nibble_wait, n_frames_scan, cast_delay, dir_key)
    if max_nibble_wait == nil then
        print('must define a max wait time in frames [36,1800)')
        return
    end
    if n_frames_scan == nil then
        n_frames_scan = 10
    end
    if cast_delay == nil then
        cast_delay = 0
    end
    printf("starting nibble manip on %d", current_frame())
    local min_frame = -1
    local min_time = 1<<32
    local counter = 0
    while counter < n_frames_scan do
        if fishing.stop then
            print('stopped')
            fishing.stop = false
            return
        end
        local frame = current_frame()
        fishing.delay_cast(cast_delay, dir_key)
        local cast_time = current_frame() - frame
        if fishing.get_rod().isFishing then
            local bite_time = fishing.get_rod().timeUntilFishingBite/1000
            local wait_frames = bite_time*60
            if min_time > wait_frames + counter then
                min_time = wait_frames + counter
                min_frame = current_frame()
            end
            min_time = math.min(min_time, wait_frames + counter)
            printf('[%d]\t%f (min_cast_frame: [%d]\t%f)', current_frame(), bite_time, min_frame-cast_time, min_time)
            if min_time < max_nibble_wait then
                print('success')
                return
            end
        end
        engine.blocking_fast_reset(frame)
        advance()
        counter = counter + 1
    end
    print('failed to find good nibble')
end

function fishing.wait_nibble()
    printf("starting nibble wait on %d", current_frame())
    local rod = fishing.get_rod()
    if not rod.isFishing or rod.timeUntilFishingBite == nil then
        print('not fishing')
        return
    end
    while not rod.isNibbling do
        advance()
        rod = fishing.get_rod()
    end
end

function fishing.manip_catch(what_fish, n_frames_scan, f_quality)
    -- what_fish: int | table[int]
    -- n_frames_scan: int
    if what_fish == nil then
        print('need to specify which fish to scan for')
        return
    end
    if n_frames_scan == nil then
        n_frames_scan = 10
    end
    if f_quality == nil then
        f_quality = 0
    end
    if type(what_fish) ~= "table" then
        what_fish = {what_fish}
    end
    local rod = fishing.get_rod()
    if not rod.isNibbling or rod.hit then
        print('cannot manip, not nibbling/already caught')
        return
    end
    printf("starting catch manip on %d", current_frame())
    local counter = 0
    while counter < n_frames_scan do
        if fishing.stop then
            print('stopped')
            fishing.stop = false
            return
        end
        local frame = current_frame()
        
        local rod = fishing.get_rod()
        if not rod.isNibbling then
            printf('[%d] stopped nibbling', frame)
            return
        end
        
        advance({keyboard={Keys.C}})
        -- wait for the menu to open or escape
        local safety_timer = 0
        while not game1.menuActive() and GetValue(RunCS("Game1.player").CurrentTool, "whichFish") == -1 do
            if safety_timer > 300 then
                break
            end
            advance()
            safety_timer = safety_timer + 1
        end

        local fish = nil
        local quality = 0
        if game1.menuActive() then
            fish = GetValue(RunCS("Game1.activeClickableMenu"), "whichFish")
            quality = GetValue(RunCS("Game1.activeClickableMenu"), "fishQuality")
        else
            fish = GetValue(RunCS("Game1.player").CurrentTool, "whichFish")
        end
        if indexof(what_fish, fish) ~= nil and quality >= f_quality then
            printf('[%d/%d]\tfound: %s (q:%d) (%d)', frame, current_frame(), game1.objectName(fish), quality, fish)
            return
        end
        printf('[%d/%d]\t%s (q:%d) (%d)', frame, current_frame(), game1.objectName(fish), quality, fish)
        --
        engine.blocking_fast_reset(frame)
        advance()
        counter = counter + 1
    end
    print('failed to find fish')
end

-- loop to see if the fish nibble is successful after the given time
-- time: int
function fishing.hit_post_time(time, n_frames_scan, cast_delay, dir_key)
    if time == nil then
        print('need to specify time')
        return
    end
    if n_frames_scan == nil then
        n_frames_scan = 10
    end
    if cast_delay == nil then
        cast_delay = 0
    end
    local rod = fishing.get_rod()
    local counter = 0
    while counter < n_frames_scan do
        if fishing.stop then
            print('stopped')
            fishing.stop = false
            return
        end
        local frame = current_frame()
        fishing.delay_cast(cast_delay, dir_key)
    end
end

return fishing

-- fish=require('scripts.fishing')


-- 39 to delay cast to depth 2 if perfectly flush
-- 55 to delay cast to depth 3 if perfectly flush


-- float fishSize = 1f;
-- fishSize *= (float)clearWaterDistance / 5f;
-- int minimumSizeContribution = 1 + lastUser.FishingLevel / 2;
-- fishSize *= (float)Game1.random.Next(minimumSizeContribution, Math.Max(6, minimumSizeContribution)) / 5f;
-- if (favBait)
-- {
--     fishSize *= 1.2f;
-- }
-- fishSize *= 1f + (float)Game1.random.Next(-10, 11) / 100f;
-- fishSize = Math.Max(0f, Math.Min(1f, fishSize));
-- bool treasure = !Game1.isFestival() && lastUser.fishCaught != null && lastUser.fishCaught.Count() > 1 && Game1.random.NextDouble() < baseChanceForTreasure + (double)lastUser.LuckLevel * 0.005 + ((getBaitAttachmentIndex() == 703) ? baseChanceForTreasure : 0.0) + ((getBobberAttachmentIndex() == 693) ? (baseChanceForTreasure / 3.0) : 0.0) + lastUser.DailyLuck / 2.0 + (lastUser.professions.Contains(9) ? baseChanceForTreasure : 0.0);

