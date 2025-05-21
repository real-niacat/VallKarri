-- i dont know how to make an ingame config - so have this
local config = {
    base_arrows = 1,
    base_arrow_inc = function(x) return x+math.sqrt(x) end,

    base_exponent = 2,
    base_exponent_inc = function(x) return x+(2*math.sqrt(x)) end,

    ante_base_inc = 1,
    ante_exponent = 2,
    ante_dollar_influence = 1,

    arrow_inc_threshold = 2,
}


local easeantecopy = ease_ante
function ease_ante(x)
    if (x < 1) then
        easeantecopy(x)
        return
    end

    if next(SMODS.find_mod('entr')) then
        if (G.GAME.chips and G.GAME.blind.chips) then


            -- print("Valid chips to enable anti-overscoring")
            -- anteshredder is a mechanic where if you overscore by far too much, the ante will be increased to compensate
            local winPot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)



            local arrowIter = config.base_exponent --despite what its name says, this is the exponent
            local arrowCount = config.base_arrows --req starts at beating blind size by ^2

            local start_ante = G.GAME.round_resets.ante
            local anteChange = 0

            if type(G.GAME.blind.chips) == "table" then
                while winPot > G.GAME.blind.chips:arrow(arrowCount, arrowIter) do
                    -- print("Must hit N{" .. arrowCount .. "}" .. arrowIter .. ", +1 ante.")
                    anteChange = anteChange + config.ante_base_inc
                    arrowIter = config.base_exponent_inc(arrowIter)
                    if arrowIter > (arrowCount+config.arrow_inc_threshold) then
                        arrowIter = config.base_exponent
                        arrowCount = config.base_arrow_inc(arrowCount)
                        anteChange = (anteChange + config.ante_base_inc) ^ 1+(config.ante_exponent/25)
                    end
                end
            end

            -- print("+"..anteChange.." ante postjen")
            anteChange = anteChange * (math.log10(G.GAME.dollars) * config.ante_dollar_influence) --every digit in your money is more ante scaling
            anteChange = anteChange ^ config.ante_exponent --keep you on your toes, ehe
            

            anteChange = math.floor(anteChange)
            --G.GAME.round_resets.ante = G.GAME.round_resets.ante + anteChange
            -- announce
            -- format: jl.a(txt, duration, size, col, snd, sndpitch, sndvol)

            if to_big(anteChange) > to_big(0) then

                local realchange = x * (1+anteChange)

                local str = "Overscored! +" .. realchange .. " ante."
                local timeWait = "1"

                jl.a(str, timeWait, 0.9, G.C.RED) --thank you oh great jenwalter for jenlib
                -- play_sound(sound,pitch,volume)

                shrdr_sfx()

                easeantecopy(realchange)
                return
            end
        end
    else 
        if (G.GAME.chips and G.GAME.blind.chips) then



            -- print("Valid chips to enable anti-overscoring")
            -- anteshredder is a mechanic where if you overscore by far too much, the ante will be increased to compensate
            local winPot = to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)



            local arrowIter = config.base_exponent --despite what its name says, this is the exponent
            local arrowCount = config.base_arrows --req starts at beating blind size by ^2

            local start_ante = G.GAME.round_resets.ante
            local anteChange = 0

            if type(G.GAME.blind.chips) == "table" then
                while winPot > G.GAME.blind.chips:arrow(arrowCount, arrowIter) do
                    -- print("Must hit N{" .. arrowCount .. "}" .. arrowIter .. ", +1 ante.")
                    anteChange = anteChange + config.ante_base_inc
                    arrowIter = config.base_exponent_inc(arrowIter)
                    if arrowIter > (arrowCount+config.arrow_inc_threshold) then
                        arrowIter = config.base_exponent
                        arrowCount = config.base_arrow_inc(arrowCount)
                        anteChange = (anteChange + config.ante_base_inc) ^ 1+(config.ante_exponent/25)
                    end
                end
            end

            -- print("+"..anteChange.." ante postjen")
            anteChange = anteChange * (math.log10(G.GAME.dollars) * config.ante_dollar_influence) --every digit in your money is more ante scaling
            anteChange = anteChange ^ config.ante_exponent --keep you on your toes, ehe
            

            anteChange = math.floor(anteChange)
            --G.GAME.round_resets.ante = G.GAME.round_resets.ante + anteChange
            -- announce
            -- format: jl.a(txt, duration, size, col, snd, sndpitch, sndvol)

            if (anteChange) > 0 then

                local realchange = x * (1+anteChange)

                local str = "Overscored! +" .. realchange .. " ante."
                local timeWait = "1"

                jl.a(str, timeWait, 0.9, G.C.RED) --thank you oh great jenwalter for jenlib
                -- play_sound(sound,pitch,volume)

                shrdr_sfx()

                easeantecopy(realchange)
                return
            end

        end
    end
    easeantecopy(x)
end

function shrdr_sfx()
    play_sound("gong", 1.4, 1)
    play_sound("timpani",0.8,2)
end

local fakeupd = Game.update

function Game:update(dt)

    fakeupd(self, dt)

    if (G.GAME.blind) then
        G.GAME.blind.overchips = to_big(G.GAME.blind.chips):arrow(config.base_arrows, config.base_exponent)
    end

end


local _create_UIBox_HUD_blind = create_UIBox_HUD_blind
function create_UIBox_HUD_blind()
    local ret = _create_UIBox_HUD_blind()


    if (G.GAME.blind.name == "Small Blind" or G.GAME.blind.name == "Big Blind") then
        return ret
    end

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
                                string = { { ref_table = G.GAME.blind, ref_value = "overchips", prefix = "Overscoring at ", suffix = " chips on boss." } },
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
