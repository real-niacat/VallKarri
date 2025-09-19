local cie = SMODS.calculate_individual_effect

function SMODS.calculate_individual_effect(effect,card,key,amount,edition)

    if string.find(key, string.lower("chips")) and G.GAME.chips_exponent then
        amount = amount ^ G.GAME.chips_exponent
    end

    if string.find(key, string.lower("mult")) and G.GAME.mult_exponent then
        amount = amount ^ G.GAME.mult_exponent
    end

    return cie(effect,card,key,amount,edition)
end

local start_run = Game.start_run
function Game:start_run(args)
    start_run(self,args)

    if not args.savetext then
        G.GAME.mult_exponent = G.GAME.mult_exponent or G.GAME.modifiers.valk_mult_expo or G.GAME.modifiers.valk_mult_expo_positive or G.GAME.modifiers.valk_mult_expo_weak
        G.GAME.chips_exponent = G.GAME.chips_exponent or G.GAME.modifiers.valk_chips_expo or G.GAME.modifiers.valk_chips_expo_positive or G.GAME.modifiers.valk_chips_expo_weak
        G.GAME.money_exponent = G.GAME.money_exponent or G.GAME.modifiers.valk_money_expo

        if G.GAME.modifiers.valk_start_late then ease_ante(G.GAME.modifiers.valk_start_late) end
        if G.GAME.modifiers.valk_free_money then ease_dollars(G.GAME.modifiers.valk_free_money) end
        if G.GAME.modifiers.valk_start_in_shop then
            G.STATE = G.STATES.SHOP
        end
    end
end

local moneyhook = ease_dollars

function ease_dollars(amount, instant)
    amount = amount ^ (G.GAME.money_exponent or 1)
    moneyhook(amount,instant)
end

local emplace = CardArea.emplace
function CardArea:emplace(card, ...)
    if G.GAME.modifiers and G.GAME.modifiers.valk_shop_sucks then

        if self == G.shop_jokers or self == G.shop_booster or self == G.shop_vouchers then
            emplace(self,card,...)
            G.E_MANAGER:add_event(Event({
                delay = 0.5,
                func = function()
                    card:start_dissolve({G.C.VALK_PRESTIGIOUS}, G.SETTINGS.GAMESPEED)
                    return true
                end,
                trigger = "after"
            }))
            
            return
        end

    end
    emplace(self,card,...)
end

function vallkarri.challenge_calc(context)
    if context.end_of_round and context.main_eval and G.GAME.modifiers.valk_tag_end_round then
        if G.GAME.modifiers.valk_tag_end_round then
            local options = {"tag_standard", "tag_charm", "tag_meteor", "tag_buffoon"}
            add_tag(Tag(options[pseudorandom("valk_endround_tag", 1, #options)]))
        end

        if G.GAME.modifiers.valk_random_tags then

        end
        
    end
end

SMODS.Challenge {
    key = "c1",
    loc_txt = {
        name = "C1"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_chips_expo", value = 0.6},
            {id = "valk_mult_expo_positive", value = 1.2},
        }
    },
}

SMODS.Challenge {
    key = "c2",
    loc_txt = {
        name = "C2"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_mult_expo", value = 0.6},
            {id = "valk_chips_expo_positive", value = 1.15}
        }
    },
}

SMODS.Challenge {
    key = "c3",
    loc_txt = {
        name = "C3"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_money_expo", value = 0.9}
        }
    },
}

SMODS.Challenge {
    key = "c4",
    loc_txt = {
        name = "C4"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_shop_sucks"},
            {id = "valk_tag_end_round"},
            {id = "valk_tag_end_round2"},
            -- cardareas: g.shop_jokers, g.shop_booster, g.shop_vouchers
        }
    },
}

SMODS.Challenge {
    key = "c5",
    loc_txt = {
        name = "C5"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_start_late", value = 3},
            {id = "valk_free_money", value = 50},
            {id = "valk_start_in_shop"},
        }
    },
}

SMODS.Challenge {
    key = "c6",
    loc_txt = {
        name = "C6"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_all_previous"},
            {id = "valk_all_previous2"},
            {id = "valk_chips_expo_weak", value = 0.85},
            {id = "valk_mult_expo_weak", value = 0.85},
            {id = "valk_money_expo", value = 0.9},
            {id = "valk_shop_sucks"},
            {id = "valk_free_money", value = 50},
            {id = "valk_start_in_shop"},
            {id = "valk_random_tags"},
        }
    },
}