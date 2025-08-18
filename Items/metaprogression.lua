local function refresh_metaprog()

    G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = to_number(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    G.PROFILES[G.SETTINGS.profile].valk_max_xp = to_number(G.PROFILES[G.SETTINGS.profile].valk_max_xp)
    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = to_number(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) 
    if type(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl) ~= "number" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = 1
    end

    if type(G.PROFILES[G.SETTINGS.profile].valk_max_xp) ~= "number" or number_format(G.PROFILES[G.SETTINGS.profile].valk_max_xp) == "Infinity" or (not G.PROFILES[G.SETTINGS.profile].valk_max_xp) then
        G.PROFILES[G.SETTINGS.profile].valk_max_xp = vallkarri.xp_required(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    end

    if type(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) ~= "number" or number_format(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) == "Infinity" or (not G.PROFILES[G.SETTINGS.profile].valk_cur_xp) then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = 0
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
    update_meta_text("curpow_text", number_format(vallkarri.calculate_power()))
end

local updhook = Game.update
function Game:update(dt)
    updhook(self, dt)
    vallkarri.update_meta_text()

    if G and G.GAME and G.HUD_META and G.HUD_META:get_UIE_by_ID("buff") then
        update_meta_text("buff", "(^" .. number_format(vallkarri.get_base_xp_exponent()) .. " XP)")
    end

    if G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].valk_cur_lvl and type(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl) == "table" then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = to_number(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl)
    end

    
end

function vallkarri.calculate_power()
    local base = G.PROFILES[G.SETTINGS.profile].valk_cur_lvl ^ 0.5

    -- ex. 
    -- vallkarri.add_power_modifier(function(m) return m^2 end)

    local mfd = {}
    for i, tab in ipairs(vallkarri.run_power_modifiers) do
        -- tab = {run = func, store = storage, dest = destruction}
        local m, ret = tab.run(base, tab.store)
        base = m
        if ret then
            tab.store = ret
        end
        if tab.dest and tab.dest(tab.store) then
            table.insert(mfd, tab)
        end
    end

    for _,val in pairs(mfd) do
        local i = find_index(val, vallkarri.run_power_modifiers)
        if i then
            table.remove(vallkarri.run_power_modifiers, i)
        end
    end
    return base

end

function create_UIBox_metaprog()
    local text_scale = 0.3
    vallkarri.update_meta_text()
    G.GAME.vallkarri = { text_display = vallkarri.update_meta_text(), power = vallkarri.calculate_power() }
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
                                    { n = G.UIT.T, config = { id = "that_fucking_space_that_i_hate", text = "  ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.T, config = { id = "buff", text = "(^1 XP)", colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.8, shadow = true, prev_value = "nil" } },
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

                            },
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = "Power: ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.85, shadow = true } },
                                    { n = G.UIT.T, config = { id = "curpow_text", text = number_format(G.GAME.vallkarri.power), colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.85, shadow = true, prev_value = "nil" } },
                                }

                            }
                        }
                    },


                }
            },


        }
    }
end

local fakestart = Game.start_run
function Game:start_run(args)
    -- print(args)
    fakestart(self, args)

    refresh_metaprog()
    vallkarri.run_xp_modifiers = {}
    vallkarri.run_power_modifiers = {}



    self.HUD_META = UIBox {
        definition = create_UIBox_metaprog(),
        config = { align = ('cli'), offset = { x = 19, y = -2.15 }, major = G.ROOM_ATTACH }
    }

    -- self.HUD_XP_CHANGE = UIBox {
    --     definition = create_UIBox_useless_bullshit(),
    --     config = { align = ('cli'), offset = { x = 19.1, y = -1.65 }, major = G.ROOM_ATTACH }
    -- }

    if not args.savetext then
        -- DO ON-START STUFF HERE
        local add_money = math.ceil(math.log(G.PROFILES[G.SETTINGS.profile].valk_cur_lvl))
        G.GAME.dollars = G.GAME.dollars + add_money
    end

    short_update_meta()
end

vallkarri.run_xp_modifiers = {}
vallkarri.run_power_modifiers = {}

---Add an xp modifier to the run, which can optionally be removed upon a destruction condition
---@param func function
---@param storage table
---@param destruction function
function vallkarri.add_xp_modifier(func, storage, destruction)
    
    vallkarri.run_xp_modifiers[#vallkarri.run_xp_modifiers+1] = {run = func, store = storage or {}, dest = destruction}

end

---Add a power modifier to the run, which can optionally be removed upon a destruction condition
---@param func function
---@param storage table
---@param destruction function
function vallkarri.add_power_modifier(func, storage, destruction)
    
    vallkarri.run_power_modifiers[#vallkarri.run_power_modifiers+1] = {run = func, store = storage or {}, dest = destruction}

end

function vallkarri.get_base_xp_exponent()
    return (G.GAME.stake ^ 0.25) * (1+(G.GAME.round/20))
end

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
    level = to_number(level)

    local req = 100 * (level ^ 2)

    return to_number(req)
end

function vallkarri.set_xp(exp)
    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = to_number(exp)
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
    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = 0
    if not from_xp then
        short_update_meta()
    end
end

function vallkarri.mod_xp(mod, relevant_card)
    refresh_metaprog()


    if not Talisman or (Talisman and not Talisman.config_file.disable_anims) then
        G.E_MANAGER:add_event(Event({
            func = function()
                vallkarri.animationless_mod_xp(mod)

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
        vallkarri.animationless_mod_xp(mod)
    end
end

function vallkarri.animationless_mod_xp(mod)
    -- stake mods
    mod = mod ^ vallkarri.get_base_xp_exponent()

    local mfd = {}
    for i, tab in ipairs(vallkarri.run_xp_modifiers) do
        -- tab = {run = func, store = storage, dest = destruction}
        local m, ret = tab.run(mod, tab.store)
        mod = m
        if ret then
            tab.store = ret
        end
        if tab.dest and tab.dest(tab.store) then
            table.insert(mfd, tab)
        end
    end

    for _,val in pairs(mfd) do
        local i = find_index(val, vallkarri.run_xp_modifiers)
        if i then
            table.remove(vallkarri.run_xp_modifiers, i)
        end
    end

    G.PROFILES[G.SETTINGS.profile].valk_cur_xp = G.PROFILES[G.SETTINGS.profile].valk_cur_xp + mod
    short_update_meta()



    while to_big(G.PROFILES[G.SETTINGS.profile].valk_cur_xp) >= to_big(G.PROFILES[G.SETTINGS.profile].valk_max_xp) do
        vallkarri.mod_level(1, true)
    end
end

local caevsttx = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    caevsttx(card, eval_type, amt, percent, dir, extra)

    if not card then return end
    if not card.area then return end
    local ind = find_index(card, card.area.cards)
    if ind then
        vallkarri.mod_xp(ind, nil, nil, card)
    end
end

local easemoneyhook = ease_dollars
function ease_dollars(mod, x)
    

    if to_big(mod) > to_big(0) then
        local lvl = G.PROFILES[G.SETTINGS.profile].valk_cur_lvl
        local multiplier = math.max(1,math.log(lvl,2)^0.2)
        local final = mod * multiplier
        final = math.max(math.floor(final), mod)
        easemoneyhook(final, x)
    else
        easemoneyhook(mod, x)
    end

    if to_big(mod) < to_big(0) then
        vallkarri.mod_xp(math.min(-mod, G.PROFILES[G.SETTINGS.profile].valk_max_xp * 0.1))
    end
end

local easeantehook = ease_ante
function ease_ante(x)
    easeantehook(x)

    if x > 0 then
        vallkarri.mod_xp(5 * x * G.GAME.round_resets.ante)
    end
end

local levelhandhook = level_up_hand
function level_up_hand(card, hand, instant, amount)
    
    levelhandhook(card, hand, instant, amount)

    if to_big(amount or 1) > to_big(0) then
        vallkarri.mod_xp(amount or 1,  card)
    end
    refresh_metaprog()
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
    local amount = blindamounthook(ante) * ((1 + (0.02 * ante)) ^ (1 + (0.2 * (G.PROFILES[G.SETTINGS.profile].valk_cur_lvl ^ 0.9))))
    local nearest = math.floor(math.log10(amount)) - 1
    -- round to nearest
    nearest = 10^nearest 
    return math.floor((amount / nearest)+0.5)*nearest
    -- x1+(0.02*ante) ^ 1+(0.2*level)
end

local amt = 2
SMODS.Voucher {
    key = "alphaboosterator",
    atlas = "main",
    pos = { x = 2, y = 7 },
    loc_txt = {
        name = "Alpha XP Boosterator",
        text = {
            "{X:dark_edition,C:white}X#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 9 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,

    in_pool = function()
        return G.GAME.round_resets.ante > amt * (2 ^ 1)
    end,

    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x,t) return x*card.ability.extra.xp end)
    end,



}


SMODS.Voucher {
    key = "betaboosterator",
    atlas = "main",
    pos = { x = 3, y = 7 },
    loc_txt = {
        name = "Beta XP Boosterator",
        text = {
            "{X:dark_edition,C:white}^#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 1.9 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,

    in_pool = function()
        return G.GAME.round_resets.ante > amt * (2 ^ 2)
    end,

    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x,t) return x^card.ability.extra.xp end)
    end,



}

SMODS.Voucher {
    key = "gammaboosterator",
    atlas = "main",
    pos = { x = 4, y = 7 },
    loc_txt = {
        name = "Gamma XP Boosterator",
        text = {
            "{X:dark_edition,C:white}^#1#{} to all XP gain",
            -- "{C:inactive}(Can spawn and be redeemed multiple times)",
            "{C:inactive}(XP Boosterators apply in the order they were obtained)",
        }
    },
    no_doe = true,
    config = { extra = { xp = 9.9 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xp } }
    end,

    in_pool = function()
        return G.GAME.round_resets.ante > amt * (2 ^ 3)
    end,

    redeem = function(self, card)
        vallkarri.add_xp_modifier(function(x,t) return x^card.ability.extra.xp end)
    end,



}