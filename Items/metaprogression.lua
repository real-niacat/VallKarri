local function refresh_metaprog()
    if type(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl) ~= "number" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = 1
    end

    if type(G.PROFILES[G.SETTINGS.profile].valk_max_xp) ~= "table" or number_format(G.PROFILES[G.SETTINGS.profile].valk_max_xp) == "Infinity" or (not G.PROFILES[G.SETTINGS.profile].valk_max_xp) then
        G.PROFILES[G.SETTINGS.profile].valk_max_xp = vallkarri.xp_required(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    end

    if type(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) ~= "table" or number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) == "Infinity" or (not G.PROFILES[G.SETTINGS.profile].valk_cur_xp) then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = to_big(0)
    end
end

function vallkarri.update_meta_text()
    return {
        level = (G.PROFILES[G.SETTINGS.profile].valk_cur_lvl),
        xp = (G.PROFILES[G.SETTINGS.profile].valk_cur_xp),
        req = (G.PROFILES[G.SETTINGS.profile].valk_max_xp),
    }
end

local function update_meta_text(uiname, value)
    G.HUD_META:get_UIE_by_ID(uiname).config.text = value
    G.HUD_META:recalculate()
end

function short_update_meta()
    update_meta_text("curxp_text", number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_xp))
    update_meta_text("maxxp_text", number_format(G.PROFILES[G.SETTINGS.profile].valk_max_xp))
    update_meta_text("curlvl_text", number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl))
end

local updhook = Game.update
function Game:update(dt)
    updhook(self, dt)
    vallkarri.update_meta_text()

    if G and G.GAME then
        G.GAME.vallkarri = { text_display = vallkarri.update_meta_text() }
    end

    if G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].valk_cur_lvl and type(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl) == "table" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = to_number(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    end
end

function create_UIBox_metaprog()
    local text_scale = 0.3
    vallkarri.update_meta_text()
    G.GAME.vallkarri = { text_display = vallkarri.update_meta_text() }
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, colour = { 0.215, 0.258, 0.267, 1 }, r = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "tl", colour = G.C.DYN_UI.BOSS_DARK, r = 0.1, minh = 0.25, minw = 3, padding = 0.08 },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = "Level ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { id = "curlvl_text", text = number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl), colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                }
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cl", padding = 0.01, maxw = 2.7 },
                                nodes = {
                                    { n = G.UIT.T, config = { id = "curxp_text", text = number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_xp), colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "curxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "xp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { text = " / ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { id = "maxxp_text", text = number_format(G.PROFILES[G.SETTINGS.profile].valk_max_xp), colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "maxxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "req", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } }
                                },

                            }
                        }
                    },


                }
            },


        }
    }
end

function create_UIBox_useless_bullshit()
    local text_scale = 0.3
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.03, colour = {0,0,0,0} },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, colour = {0,0,0,0}, r = 0.1 },
                nodes = {
                    { n = G.UIT.T, config = { id = "xp_change", text = "+0 XP", colour = G.C.UI.TEXT_LIGHT, scale = text_scale/1.2, shadow = true, prev_value = "nil" } },
                }
            },


        }
    }
end
local xp_change = false

local fakestart = Game.start_run
function Game:start_run(args)
    -- print(args)
    fakestart(self, args)
    
    refresh_metaprog()
    vallkarri.run_xp_modifiers = {}



    self.HUD_META = UIBox {
        definition = create_UIBox_metaprog(),
        config = { align = ('cli'), offset = { x = 19, y = -2.25 }, major = G.ROOM_ATTACH }
    }

    if xp_change then
        self.HUD_XP_CHANGE = UIBox {
            definition = create_UIBox_useless_bullshit(),
            config = { align = ('cli'), offset = { x = 19.1, y = -1.65 }, major = G.ROOM_ATTACH }
        }
    end

    if not args.savetext then 
        -- DO ON-START STUFF HERE
        local add_money = math.floor(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl / 25) * 0.5
        G.GAME.dollars = G.GAME.dollars + add_money

        local add_levels = math.ceil(math.log(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl, 2.5))
        for name, hand in pairs(G.GAME.hands) do
            G.GAME.hands[name].level = G.GAME.hands[name].level + add_levels
            G.GAME.hands[name].chips = G.GAME.hands[name].chips + (G.GAME.hands[name].l_chips * add_levels)
            G.GAME.hands[name].mult = G.GAME.hands[name].mult + (G.GAME.hands[name].l_mult * add_levels)
        end
    end
end

-- put functions
-- defaults to + if no operator given
vallkarri.xp_modifiers = {

}

vallkarri.run_xp_modifiers = {

}

vallkarri.level_cap = 1e300 --have fun :)

function vallkarri.debug_reset_lvl()
    if true then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = 1
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = 0
        G.PROFILES[G.SETTINGS.profile].valk_max_xp = vallkarri.xp_required(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
        short_update_meta()
    end
end

-- gets the xp required for the specified level
function vallkarri.xp_required(level)
    level = to_big(level)
    local arrows = 0
    local exp = 1

    local nlv = to_big(level) -- shorthand. dumb i know
    arrows = nlv:tetrate(0.07)
    exp = math.log(nlv, 2.2)

    if (level < to_big(1000)) and (arrows > to_big(1)) then
        arrows = 1    
    end

    local req = 100 * to_big(level):arrow(math.floor(arrows), (level^0.5) ^ exp)
    if to_big(req) == to_big(math.huge) then
        return to_big(100)
    end
    return req
end

function vallkarri.set_xp(exp)
    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = to_big(exp) --obligatory to_big so that end users can eval this safely
    short_update_meta()
end

function vallkarri.mod_level(amount, from_xp)
    G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = G.PROFILES[G.SETTINGS.profile].valk_cur_lvl + amount

    if G.PROFILES[G.SETTINGS.profile].valk_cur_lvl > vallkarri.level_cap then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = vallkarri.level_cap
    else
        G.HUD_META:get_UIE_by_ID("curlvl_text"):juice_up()
        G.HUD_META:get_UIE_by_ID("maxxp_text"):juice_up()
    end
    G.PROFILES[G.SETTINGS.profile].valk_max_xp = vallkarri.xp_required(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = to_big(0)
    if not from_xp then
        short_update_meta()
    end
end

function vallkarri.mod_xp(mod, operator, level_multiplier, relevant_card)
    refresh_metaprog()
    if not operator then
        operator = "+"
    end

    if not level_multiplier then
        level_multiplier = 1
    end


    if not Talisman.config_file.disable_anims then
        G.E_MANAGER:add_event(Event({
            func = function()
                vallkarri.animationless_mod_xp(mod, operator, level_multiplier)

                G.HUD_META:get_UIE_by_ID("curxp_text"):juice_up()

                if xp_change then
                    local str = "+" .. number_format(mod) .. " XP"
                    G.HUD_XP_CHANGE:get_UIE_by_ID("xp_change").config.text = str
                    G.HUD_XP_CHANGE:recalculate()

                    G.HUD_XP_CHANGE:get_UIE_by_ID("xp_change"):juice_up()
                end

                if relevant_card and relevant_card.juice_up then
                    relevant_card:juice_up()
                end



                return true
            end,
        }))
    else
        vallkarri.animationless_mod_xp(mod, operator, level_multiplier)
    end
end

function vallkarri.animationless_mod_xp(mod, operator, level_multiplier)

    -- stake mods
    mod = mod ^ (G.GAME.stake/4)
    

    for _,func in ipairs(vallkarri.xp_modifiers) do
        mod = func(mod)
    end

    for _,func in ipairs(vallkarri.run_xp_modifiers) do
        mod = func(mod)
    end

    if operator == "+" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = G.PROFILES[G.SETTINGS.profile].valk_cur_xp + mod
    end

    if operator == "*" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = G.PROFILES[G.SETTINGS.profile].valk_cur_xp * mod
    end

    if operator == "^" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = G.PROFILES[G.SETTINGS.profile].valk_cur_xp ^ mod
    end

    if operator == "^^" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = G.PROFILES[G.SETTINGS.profile].valk_cur_xp:tetrate(mod)
    end
    short_update_meta()



    while G.PROFILES[G.SETTINGS.profile].valk_cur_xp >= G.PROFILES[G.SETTINGS.profile].valk_max_xp do
        vallkarri.mod_level(level_multiplier or 1, true)
    end
end

local caevsttx = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    caevsttx(card, eval_type, amt, percent, dir, extra)

    local ind = find_index(card, card.area.cards)
    if ind then
        vallkarri.mod_xp(ind, nil, nil, card)
    end
end

local easemoneyhook = ease_dollars
function ease_dollars(mod, x)
    local add_money_per = math.floor(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl / 2) * 0.02

    easemoneyhook(mod + add_money_per, x)

    if to_big(mod) < to_big(0) then
        vallkarri.mod_xp(math.min(-mod, G.PROFILES[G.SETTINGS.profile].valk_max_xp * 0.1))
    end
end

local easeantehook = ease_ante
function ease_ante(x)
    easeantehook(x)

    if to_big(x) > to_big(0) then
        vallkarri.mod_xp(5 * x)
    end
end

local levelhandhook = level_up_hand
function level_up_hand(card, hand, instant, amount)
    refresh_metaprog()
    levelhandhook(card, hand, instant, amount)

    if to_big(amount) > to_big(0) then
        vallkarri.mod_xp(amount, nil, nil, card)
    end
end

-- local calceff = SMODS.calculate_individual_effect
-- function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    
--     local count = math.log(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl, 1.2) * 0.025
--     -- 2.5% buff to all scoring effects for every 50 levels
--     -- print("effect")
--     -- print(effect)
--     -- print("amount")
--     -- print(amount)
--     if type(amount) == "number" or (type(amount) == "table" and amount.tetrate) then
--         amount = amount * 1+count
--     end

--     for n,obj in pairs(effect) do
--         if type(obj) == "number" or (type(obj) == "table" and obj.tetrate) then
--             effect[n] = effect[n] * 1+count
--         end 
--     end

--     return calceff(effect, scored_card, key, amount, from_edition)

-- end

-- local evalplayscorehook = evaluate_play_final_scoring

-- function evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
--     refresh_metaprog()
--     mult = mult + ((G.PROFILES[G.SETTINGS.profile].valk_cur_lvl - 1) * 0.1)

--     evalplayscorehook(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
-- end

local blindamounthook = get_blind_amount

function get_old_blind_amount(ante)
    return blindamounthook(ante)
end
function get_blind_amount(ante)
    refresh_metaprog()
    return blindamounthook(ante) * ((1+(0.02 * ante))^(1+(0.2*(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl^0.825))))
    -- x1+(0.02*ante) ^ 1+(0.2*level)
end
local vouchers_enabled = true

if vouchers_enabled then

    SMODS.Voucher {
        key = "alphaboosterator",
        atlas = "main",
        pos = {x=2, y=7},
        loc_txt = {
            name = "Alpha XP Boosterator",
            text = {
                "{X:dark_edition,C:white}X#1#{} to all XP gain",
                -- "{C:inactive}(Can spawn and be redeemed multiple times)",
                "{C:inactive}(XP Boosterators apply in the order they were obtained)",
            }
        },
        no_doe = true,
        config = {extra = {xp = 9}},

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xp}}
        end,

        in_pool = function()
            return G.GAME.round_resets.ante > 1500*(2^1)
        end,

        redeem = function(self, card)
            vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers+1] = function(n)
                return n*card.ability.extra.xp
            end
        end,
        


    }


    SMODS.Voucher {
        key = "betaboosterator",
        atlas = "main",
        pos = {x=3, y=7},
        loc_txt = {
            name = "Beta XP Boosterator",
            text = {
                "{X:dark_edition,C:white}^#1#{} to all XP gain",
                -- "{C:inactive}(Can spawn and be redeemed multiple times)",
                "{C:inactive}(XP Boosterators apply in the order they were obtained)",
            }
        },
        no_doe = true,
        config = {extra = {xp = 1.9}},

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xp}}
        end,

        in_pool = function()
            return G.GAME.round_resets.ante > 1500*(2^2)
        end,

        redeem = function(self, card)
            vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers+1] = function(n)
                return n^card.ability.extra.xp
            end
        end,
        


    }

    SMODS.Voucher {
        key = "gammaboosterator",
        atlas = "main",
        pos = {x=4, y=7},
        loc_txt = {
            name = "Gamma XP Boosterator",
            text = {
                "{X:dark_edition,C:white}^^#1#{} to all XP gain",
                "Effect is re-applied when {C:attention}blind{} defeated",
                "When {C:attention}boss blind{} defeated, {X:dark_edition,C:white}+^^#2#{} XP Gain",
                -- "{C:inactive}(Can spawn and be redeemed multiple times)",
                "{C:inactive}(XP Boosterators apply in the order they were obtained)",
            }
        },
        no_doe = true,
        config = {extra = {xp = 1.09, gain = 0.09}},

        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.xp, card.ability.extra.gain}}
        end,

        in_pool = function()
            return G.GAME.round_resets.ante > 1500*(2^3)
        end,

        redeem = function(self, card)
            vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers+1] = function(n)
                return to_big(n):tetrate(card.ability.extra.xp)
            end
        end,

        calculate = function(self, card, context)
            if context.end_of_round and context.main_eval then
                vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers+1] = function(n)
                    return to_big(n):tetrate(card.ability.extra.xp)
                end
                if G.GAME.blind.boss then
                    card.ability.extra.xp = card.ability.extra.xp + card.ability.extra.gain
                end
            end
        end
        


    }

end

