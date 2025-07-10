-- i'm not making these configurable ingame
-- sorry!

function config_reset()
    G.GAME.ante_config = {
        base_arrows = 1,

        base_exponent = 5,

        ante_base_inc = 1,
        ante_exponent = 1,

        arrow_inc_threshold = 1,
        arrow_exponent = 1.15,

        limit = 64,
    }
end



local easeantecopy = ease_ante
function ease_ante(x)
    -- print("starting")
    x = to_big(x)


    if (x < to_big(1)) then
        easeantecopy(to_number(x))
        return
    end

    if (G.GAME.disable_ante_gain and x > to_big(0)) then
        x = 0
    end
    -- print(G.GAME.chips and G.GAME.blind.chips)

    if (G.GAME.chips and G.GAME.blind.chips) then
        
        local anteChange = get_ante_change()
        display_ante_changes(anteChange)
        G.GAME.win_ante = (G.GAME.win_ante + to_number(anteChange))
        easeantecopy(to_number(anteChange)+to_number(x))
        
        return
    end
    

    easeantecopy(to_number(x))
end

function display_ante_changes(change)
    if (change == 0) then
        return
    end

    local str = "Overscored! +" .. change .. " ante."
    local timeWait = "1"

    basic_text_announce(str, timeWait, 0.9, G.C.RED)

    shrdr_sfx()

    
    return
end

local roundcopy = end_round
function end_round()
    if (type(G.GAME.round_resets.ante) == "table") then
        G.GAME.win_ante = to_big(G.GAME.win_ante)
    end
    roundcopy()

    if check_superwin() then
        return
    end
end

function get_ante_change(theoretical_score, debug)

    local winPot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)
    if theoretical_score then
        winPot = to_big(theoretical_score)
    end

    if not (G.GAME.ante_config) then
        config_reset()
    end



    local arrowIter = G.GAME.ante_config.base_exponent --despite what its name says, this is the exponent
    local arrowCount = G.GAME.ante_config.base_arrows --req starts at beating blind size by ^2
    local start_ante = G.GAME.round_resets.ante
    local anteChange = 0
    local scalefactor = to_big(1)

    -- 
            
    local i = 1

    -- print(type(G.GAME.blind.chips))

    if type(G.GAME.blind.chips) == "table" then

        if debug then
            print("requires " .. G.GAME.blind.chips:arrow(math.floor(arrowCount), to_big(arrowIter) * scalefactor) .. " to overscore")
            print("overscored by " .. winPot)
        end

        while winPot > G.GAME.blind.chips:arrow(math.floor(arrowCount), to_big(arrowIter) * scalefactor) do
            i = i + 1
            if debug then print("Iteration: " .. i .. ", Must hit" .. G.GAME.blind.chips .. "{" .. arrowCount .. "}" .. tostring(to_big(arrowIter) * scalefactor)) end
            scalefactor = scalefactor:pow(2):mul(2)
            anteChange = anteChange + G.GAME.ante_config.ante_base_inc
            arrowIter = arrowIter + 1
            if arrowIter > (G.GAME.ante_config.arrow_inc_threshold) then
                arrowIter = G.GAME.ante_config.base_exponent
                arrowCount = arrowCount * G.GAME.ante_config.arrow_exponent
                anteChange = (anteChange + G.GAME.ante_config.ante_base_inc) ^ 1+(G.GAME.ante_config.ante_exponent/25)
            end
        end
    end

    -- print("+"..anteChange.." ante postjen")
    anteChange = anteChange ^ (G.GAME.ante_config.ante_exponent ^ math.log10(G.GAME.round_resets.ante) ) --keep you on your toes, ehe

    

    local arrow_diff = #to_big(G.GAME.chips).array - #to_big(G.GAME.blind.chips).array
    if arrow_diff ~= 0 then
        anteChange = anteChange ^ ((arrow_diff ^ 0.75) / 10)
    end
    
    anteChange = math.floor(anteChange) 
    -- you are lucky i decided to round down

    return anteChange
end


local unlockcopy = check_for_unlock
function check_for_unlock(args)
    if (args.ante and args.type == "ante_up" and type(args.ante) == "table") then
        if args.ante >= to_big(4) then
            unlock_achievement('ante_up')
        end
        if args.ante >= to_big(8) then
            unlock_achievement('ante_upper')
        end
        return
    end
    unlockcopy(args)
end

function check_superwin()

    if (G.GAME.round_resets.ante == math.huge or to_big(G.GAME.round_resets.ante) >= to_big(1e307)) then
        superwin_game()
        return true
    end
    return false

end



function shrdr_sfx()
    play_sound("gong", 1.4, 1)
    play_sound("timpani",0.8,2)
end

local fakeupd = Game.update
local alltime = 0

function Game:update(dt)
    alltime = alltime + dt
    fakeupd(self, dt)

    if (G.GAME.blind and G.GAME.ante_config) then

        if (G.GAME.blind.boss) then
            G.GAME.blind.overchips = "Overscoring at " .. tostring(to_big(G.GAME.blind.chips):arrow(math.floor(G.GAME.ante_config.base_arrows), to_big(G.GAME.ante_config.base_exponent)))
        else
            G.GAME.blind.overchips = ""
        end
    end

    if (G.GAME.ante_config and G.GAME.round_resets.ante and to_big(G.GAME.round_resets.ante) > to_big(G.GAME.ante_config.limit) ) then
        G.GAME.round_resets.ante_disp = number_format(G.GAME.round_resets.ante) .. "X"
    end

end


local _create_UIBox_HUD_blind = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
    local ret = _create_UIBox_HUD_blind()


    -- if (not G.GAME.blind.boss) then
    --     return ret
    -- end

    local node = ret.nodes[2]
    node.nodes[#node.nodes + 1] = {
        n = G.UIT.R,
        config = { align = "cm", minh = 0.6, r = 0.1, emboss = 0.05, colour = G.C.DYN_UI.MAIN },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", minw = 3 },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = DynaText({
                                string = { { ref_table = G.GAME.blind, ref_value = "overchips"} },
                                colours = { G.C.UI.TEXT_LIGHT },
                                shadow = true,
                                float = true,
                                scale = 0.27,
                                y_offset = -4,
                            }),
                            id = "ante_overscoreText",
                        },
                    },
                },
            },
        },
    }
    return ret
end

local gba = get_blind_amount
function get_blind_amount(ante)
    ante = to_big(ante)
    if ante <= (G.GAME.ante_config and to_big(G.GAME.ante_config.limit) or to_big(1500)) then --use 1500 as fallback, config is only generated when run starts
        return gba(to_number(ante))
    end


    if (G.GAME.round_resets.ante ~= math.huge and ante <= to_big(1e300)) then
        -- print("scaling increase branch 1 ")
        local score = to_big(10)
        local arrows = math.log10(ante)

        local antelog = math.log10(ante)
        local min_arrows, max_arrows = 1, 100000
        local min_log, max_log = 1, 125

        local t = (antelog - min_log) / (max_log - min_log)
        t = math.max(0, math.min(1, t))

        local eased = t^3
        --i love exponents

        arrows = min_arrows + (max_arrows - min_arrows) * eased
        

        score = score:arrow(math.ceil(arrows),math.sqrt(ante))

        
        if (score ~= math.huge) then
            return score
        else
            return math.huge
        end

    else
        -- print("scaling increase branch 2")

        return math.huge

    end
end