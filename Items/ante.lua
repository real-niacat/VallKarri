-- i'm not making these configurable ingame
-- sorry!

function config_reset()
    G.GAME.ante_config = {
        limit = 32
    }
end



local easeantecopy = ease_ante
function ease_ante(x)
    -- print("starting")

    x = to_number(x)

    if (x < 1) or (not vallkarri.config.overscoring) then
        easeantecopy(to_number(x))
        return
    end

    if (G.GAME.disable_ante_gain and x > 0) then
        x = 0
    end
    -- print(G.GAME.chips and G.GAME.blind.chips)

    if (G.GAME.chips and G.GAME.blind.chips) then
        local anteChange = get_ante_change()
        anteChange = math.ceil(anteChange)
        display_ante_changes(anteChange)
        easeantecopy(x)
        vallkarri.add_effective_ante_mod(to_number(anteChange), "+")
        
        return
    end

    easeantecopy(x)
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

function get_ante_change(theoretical_score, debug)

    local win_pot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)
    local ovsc = overscore_threshhold()
    win_pot = (theoretical_score and to_big(theoretical_score)) or win_pot 

    if to_big(win_pot) < to_big(ovsc) then
        return 0
    end

    win_pot = to_big(win_pot)

    local anteChange = 0
    local theochange = to_big(0)
    local inc = 1
    while theochange < win_pot do
        anteChange = math.floor(anteChange + inc)
        inc = inc * 1.1
        theochange = to_big(get_blind_amount(anteChange+G.GAME.round_resets.ante))
        -- print(anteChange, theochange)
    end

    return math.max(anteChange ^ 0.6, anteChange / 2)
end

function overscore_threshhold()
    local change = G.GAME.overscoring_threshold_base or 10 
    return get_blind_amount(change + G.GAME.round_resets.ante)
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
            local num = number_format(overscore_threshhold())
            G.GAME.blind.overchips = vallkarri.config.overscoring and ("Overscoring at " .. num) or "Overscoring Disabled"
        else
            G.GAME.blind.overchips = ""
        end
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

