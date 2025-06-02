-- i'm not making these configurable ingame
-- sorry!
ante_config = {
    
}

function config_reset()
    ante_config = {
        base_arrows = 1,

        base_exponent = 5,

        ante_base_inc = 1,
        ante_exponent = 1,

        arrow_inc_threshold = 1,
        arrow_exponent = 1.15,

        limit = 1500,
    }
end

config_reset()

local easeantecopy = ease_ante
function ease_ante(x)


    x = to_big(x)
    if (x < to_big(1)) then
        easeantecopy(x)
        return
    end


    if (G.GAME.chips and G.GAME.blind.chips) then
        local winPot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)



            local arrowIter = ante_config.base_exponent --despite what its name says, this is the exponent
            local arrowCount = ante_config.base_arrows --req starts at beating blind size by ^2

            local start_ante = G.GAME.round_resets.ante
            local anteChange = 0
            local scalefactor = to_big(2)
            
            local i = 1

            if type(G.GAME.blind.chips) == "table" then
                while winPot > G.GAME.blind.chips:arrow(math.floor(arrowCount), to_big(arrowIter) * scalefactor) do
                    i = i + 1
                    print("Iteration: " .. i .. ", Must hit" .. G.GAME.blind.chips .. "{" .. arrowCount .. "}" .. tostring(to_big(arrowIter) * scalefactor))
                    scalefactor = scalefactor:tetrate(2)
                    anteChange = anteChange + ante_config.ante_base_inc
                    arrowIter = arrowIter + 1
                    if arrowIter > (ante_config.arrow_inc_threshold) then
                        arrowIter = ante_config.base_exponent
                        arrowCount = arrowCount * ante_config.arrow_exponent
                        anteChange = (anteChange + ante_config.ante_base_inc) ^ 1+(ante_config.ante_exponent/25)
                    end
                end
            end

            -- print("+"..anteChange.." ante postjen")
            anteChange = anteChange ^ ante_config.ante_exponent --keep you on your toes, ehe
            

            anteChange = math.floor(anteChange)
            --G.GAME.round_resets.ante = G.GAME.round_resets.ante + anteChange
            -- announce
            -- format: jl.a(txt, duration, size, col, snd, sndpitch, sndvol)

        display_ante_changes(anteChange)
        easeantecopy(anteChange)

    end
    

    easeantecopy(x)
end

function display_ante_changes(change)
    if (change == 0) then
        return
    end

    local str = "Overscored! +" .. change .. " ante."
    local timeWait = "1"

    jl.a(str, timeWait, 0.9, G.C.RED) --thank you oh great jenwalter for jenlib
                -- play_sound(sound,pitch,volume)

    shrdr_sfx()

    
    return
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

    if (G.GAME.blind) then

        if (G.GAME.blind.boss) then
            G.GAME.blind.overchips = "Overscoring active."
        else
            G.GAME.blind.overchips = ""
        end
    end

    if (G.GAME.round_resets.ante and to_big(G.GAME.round_resets.ante) > to_big(ante_config.limit) ) then
        G.GAME.round_resets.ante_disp = number_format(G.GAME.round_resets.ante) .. "X"

        G.GAME.round_resets.ante_disp = corrupt_text(G.GAME.round_resets.ante_disp, 0.05)
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
    if (ante <= to_big(ante_config.limit)) then
        return gba(to_number(ante))
    end


    if (G.GAME.round_resets.ante ~= math.huge and ante <= to_big(1e300)) then
        -- print("scaling increase branch 1 ")
        local score = to_big(10)
        local arrows = math.log10(ante)

        -- Map ante logarithmically from 1-308 (for antes 1-1e308) to 1-10000 arrows
        -- Use an easing function to keep arrows low at first, then ramp up faster near the end
        local antelog = math.log10(ante)
        local min_arrows, max_arrows = 1, 100000
        local min_log, max_log = 1, 308

        local t = (antelog - min_log) / (max_log - min_log)
        t = math.max(0, math.min(1, t))

        local eased = t^3
        --i love exponents

        arrows = min_arrows + (max_arrows - min_arrows) * eased
        

        score = score:arrow(math.ceil(arrows),math.sqrt(ante))

        
        if (score ~= math.huge) then
            return score
        else
            return get_a_somewhat_large_number()
        end

    else
        -- print("scaling increase branch 2")

        return get_a_somewhat_large_number()

    end
end