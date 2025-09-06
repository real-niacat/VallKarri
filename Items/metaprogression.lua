

function vallkarri.calculate_power()
    local base = (G.GAME.current_level or 1) ^ 0.5

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
                                    { n = G.UIT.T, config = { id = "curlvl_text", ref_table = G.GAME, ref_value = "current_level_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.T, config = { id = "that_fucking_space_that_i_hate", text = "  ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    { n = G.UIT.T, config = { id = "buff", ref_table = G.GAME, ref_value = "xp_exponent_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.8, shadow = true, prev_value = "nil" } },
                                }
                            },
                            {
                                n = G.UIT.R,
                                config = { align = "cl", padding = 0.01, maxw = 2.7 },
                                nodes = {
                                    { n = G.UIT.T, config = { id = "curxp_text", ref_table = G.GAME, ref_value = "current_xp_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "curxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "xp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { text = " / ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } },
                                    { n = G.UIT.T, config = { id = "maxxp_text", ref_table = G.GAME, ref_value = "required_xp_disp", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true, prev_value = "nil" } },
                                    -- { n = G.UIT.T, config = { id = "maxxp_text", ref_table = G.GAME.vallkarri.text_display, ref_value = "req", colour = G.C.UI.TEXT_LIGHT, scale = text_scale, shadow = true } }
                                },

                            },
                            {
                                n = G.UIT.R,
                                config = { align = "tl", padding = 0.01, maxw = 2 },
                                nodes = {
                                    { n = G.UIT.T, config = { text = "Power: ", colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.85, shadow = true } },
                                    { n = G.UIT.T, config = { id = "curpow_text", ref_table = G.GAME, ref_value = "valk_power", colour = G.C.UI.TEXT_LIGHT, scale = text_scale*0.85, shadow = true, prev_value = "nil" } },
                                }

                            }
                        }
                    },


                }
            },


        }
    }
end

local upd = Game.update
function Game:update(dt)
    upd(self, dt)

    if G.GAME.current_level then
        G.GAME.current_level_disp = number_format(G.GAME.current_level)
    end

    if G.GAME.current_xp then
        G.GAME.current_xp_disp = number_format(G.GAME.current_xp)
    end

    if G.GAME.required_xp then
        G.GAME.required_xp_disp = number_format(G.GAME.required_xp)
    end

end

local fakestart = Game.start_run
function Game:start_run(args)
    -- print(args)
    fakestart(self, args)

    self.GAME.current_level = 1
    self.GAME.current_xp = 0
    self.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
    self.GAME.valk_power = 1

    vallkarri.run_xp_modifiers = {}
    vallkarri.run_power_modifiers = {}



    self.HUD_META = UIBox {
        definition = create_UIBox_metaprog(),
        config = { align = ('cli'), offset = { x = 19, y = -2.15 }, major = G.ROOM_ATTACH }
    }
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

-- gets the xp required for the specified level


function vallkarri.mod_level(amount, from_xp)
    local req = vallkarri.xp_required(G.GAME.current_level)
    G.GAME.current_level = G.GAME.current_level + amount

    G.HUD_META:get_UIE_by_ID("curlvl_text"):juice_up()
    G.HUD_META:get_UIE_by_ID("maxxp_text"):juice_up()

    G.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
    if from_xp then
        G.GAME.current_xp = G.GAME.current_xp - req
    end
    
    
end
local compress_events = false
local active_xp_queue = 0
local xp_queued = 0
function vallkarri.mod_xp(mod, relevant_card)
    


    if (not Talisman or (Talisman and not Talisman.config_file.disable_anims)) and active_xp_queue < 128 then --prevent excessive retriggers or whatever from causing problems
        active_xp_queue = active_xp_queue + 1
        -- print("+1 event, now " .. active_xp_queue)
        G.E_MANAGER:add_event(Event({
            func = function()
                vallkarri.animationless_mod_xp(mod)

                G.HUD_META:get_UIE_by_ID("curxp_text"):juice_up()

                if relevant_card and relevant_card.juice_up then
                    relevant_card:juice_up()
                end


                active_xp_queue = active_xp_queue - 1
                -- print("-1 event, now " .. active_xp_queue)
                return true
            end,
            
        }), 'other')
    else
        -- emergency optimization
        -- print("!!QUEUEING SLOWLY")
        if compress_events then
            xp_queued = xp_queued + mod
        else
            vallkarri.animationless_mod_xp(mod)
        end 
        

        
    end
end



function vallkarri.reset_levels()
    G.GAME.current_level = 1
    G.GAME.current_xp = 0
    G.GAME.required_xp = vallkarri.xp_required(G.GAME.current_level)
end

function vallkarri.metacalc(context)
    G.GAME.xp_exponent_disp = "(^" .. vallkarri.get_base_xp_exponent() .. " XP)"
    G.GAME.valk_power = vallkarri.calculate_power()
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

    G.GAME.current_xp = G.GAME.current_xp + mod


    G.GAME.current_xp = math.floor(G.GAME.current_xp)
    G.GAME.required_xp = math.floor(G.GAME.required_xp)

    if to_big(G.GAME.current_xp) > to_big(G.GAME.required_xp)*16 then
        vallkarri.mod_level(math.floor(vallkarri.xp_to_level(G.GAME.current_xp + vallkarri.level_to_xp(G.GAME.current_level)) - G.GAME.current_level))
        G.GAME.current_xp = 0
    end


    while to_big(G.GAME.current_xp) >= to_big(G.GAME.required_xp) do
        vallkarri.mod_level(1, true)
    end
end

function vallkarri.xp_to_level(x)
    return math.sqrt(0.25 + (x/50)) - 0.5
end

function vallkarri.level_to_xp(l)
    return 50 * (l + (l ^ 2))
end

function vallkarri.xp_required(level)
    level = to_number(level)

    local req = 100 * level

    return to_number(req)
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
        local multiplier = math.max(1,math.log(G.GAME.current_level,2))
        local final = mod * multiplier
        final = math.max(math.floor(final), mod)
        easemoneyhook(final, x)
    else
        easemoneyhook(mod, x)
    end

    if to_big(mod) < to_big(0) then
        vallkarri.mod_xp(-mod)
    end
end

local easeantehook = ease_ante
function ease_ante(x)
    easeantehook(x)

    if x > 0 then
        vallkarri.mod_xp((5 * x) ^ G.GAME.round_resets.ante)
    end
end

local levelhandhook = level_up_hand
function level_up_hand(card, hand, instant, amount)
    
    levelhandhook(card, hand, instant, amount)

    if to_big(amount or 1) > to_big(0) then
        vallkarri.mod_xp((amount or 1) * 25,  card)
    end
end

local blindamounthook = get_blind_amount

function get_old_blind_amount(ante)
    return blindamounthook(ante)
end

function get_blind_amount(ante)
    local amount = blindamounthook(ante)
    local multiplier = (((1 + (0.02 * ante)) ^ (1 + (0.2 * (math.max((G.GAME.current_level or 0)-5, 0) ^ 0.9))))) ^ 0.9
    -- print(multiplier .. " at level " ..  (G.GAME.current_level or 0))
    amount = amount * multiplier

    if to_big(amount) > to_big(10 ^ 308) then
        return amount
    end

    local nearest = math.floor(math.log10(amount)) - 1
    -- round to 2 sigfigs
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